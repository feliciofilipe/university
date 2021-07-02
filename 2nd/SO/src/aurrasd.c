#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include "../includes/request.h"
#include "../includes/response.h"
#include "../includes/tuple.h"

#define CLIENT_TO_SERVER_FIFO "tmp/client_to_server_fifo"

typedef struct filter {
    char name[64];
    char bin[64];
    int running;
    int max;
} Filter;

char filters_folder[1024];
int available_filters = 0;

typedef struct process {
    int client_pid;
    int fork_pid;
    Tuple tuple_list[64];
    int tuple_list_size;
    char filters_names[64][64];
    char input[1024];
    char output[1024];
    int number_filters;
    int active;
    int inqueue;
} Process;

int server_pid;

int number_total_filters = 0;
Filter filters[128];

int number_processes = 0;
Process processes[1024];

Process process_queue[16][1024];
int queue_size[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int queue_total_size = 0;

int valid_filter(char* filter_name) {
    int bool = 0;
    int i;
    for (i = 0; i < number_total_filters && !bool; i++)
        bool |= (strcmp(filter_name, filters[i].name) == 0);
    return bool;
}

int valid_filters(char filters_names[64][64], int number_filters, int* index) {
    int i;
    int bool = 1;
    for (i = 0; i < number_filters && bool; i++)
        bool &= valid_filter(filters_names[i]);
    *index = i - 1;
    return bool;
}

void send_message(char* message, int pid, int flag) {
    Response response;
    response.argc = 1;
    response.flag = flag;
    strcpy(response.argv[0], message);
    int server_to_client_fifo;
    char server_to_client_fifo_name[128];
    sprintf(server_to_client_fifo_name, "tmp/%d", pid);
    if ((server_to_client_fifo = open(server_to_client_fifo_name, O_WRONLY)) ==
        -1) {
        /* ERROR */
    }
    write(server_to_client_fifo, &response, sizeof(Response));
    close(server_to_client_fifo);
    if (flag) unlink(server_to_client_fifo_name);
}

void send_status(int pid) {
    Response response;
    response.argc = 0;
    int i, j;

    for (i = 0; i < number_processes; i++) {
        if (processes[i].active) {
            char aux[1024] = "";
            for (j = 0; j < processes[i].number_filters; j++) {
                if(j != 0) strcat(aux, " ");
                strcat(aux, processes[i].filters_names[j]);
            }

            char process[4096];
            sprintf(process, "task #%d: transform %s %s %s\n", i + 1,
                    processes[i].input, processes[i].output, aux);
            strcpy(response.argv[response.argc++], process);
        }
    }

    for (i = 0; i < number_total_filters; i++) {
        char filter_status[1024];
        sprintf(filter_status, "filter %s: %d/%d (running/max)\n",
                filters[i].name, filters[i].running, filters[i].max);
        strcpy(response.argv[response.argc++], filter_status);
    }
    char pid_status[64];
    sprintf(pid_status, "pid: %d\n", server_pid);
    strcpy(response.argv[response.argc++], pid_status);
    int server_to_client_fifo;
    char server_to_client_fifo_name[128];
    sprintf(server_to_client_fifo_name, "tmp/%d", pid);
    if ((server_to_client_fifo = open(server_to_client_fifo_name, O_WRONLY)) ==
        -1) {
        /* ERROR */
    }
    response.flag = 1;
    write(server_to_client_fifo, &response, sizeof(Response));
    close(server_to_client_fifo);
    unlink(server_to_client_fifo_name);
}

ssize_t readln(int fd, char* line, size_t size) {
    int i = 0;
    while (i < size && read(fd, line + i, 1) > 0 && line[i++] != '\n')
        ;
    return i;
}

void read_config_file(char* path) {
    int fd = open(path, O_RDONLY);
    char buf[64];
    while ((readln(fd, buf, 64)) > 0) {
        char* token = strtok(buf, " ");
        int i;
        for (i = 0; i < 3 && token != NULL; i++) {
            switch (i) {
                case 0:
                    strcpy(filters[number_total_filters].name, token);
                    break;
                case 1:
                    strcpy(filters[number_total_filters].bin, token);
                    break;
                case 2:
                    filters[number_total_filters].max = atoi(token);
                    available_filters += atoi(token);
                    break;
            }
            token = strtok(NULL, " ");
        }
        filters[number_total_filters].running = 0;
        number_total_filters++;
    }
    close(fd);
}

int get_filter_index(char* name) {
    int i;
    for (i = 0; i < number_total_filters; i++)
        if (strcmp(name, filters[i].name) == 0) return i;
    return -1;
}

int check_filter_impossibility(int index, int number) {
    return number > filters[index].max;
}

int check_filters_impossibility(Tuple tuple_list[64], int tuple_list_size) {
    int bool = 0;
    int i;
    for (i = 0; i < tuple_list_size; i++) {
        int filter_index = get_filter_index(tuple_list[i].filter);
        bool |= check_filter_impossibility(filter_index, tuple_list[i].number);
    }
    return bool;
}

int check_filter_availability(int index, int number) {
    return filters[index].running + number <= filters[index].max;
}

int check_filters_availability(Tuple tuple_list[64], int tuple_list_size) {
    int bool = 1;
    int i;
    for (i = 0; i < tuple_list_size && bool; i++) {
        int filter_index = get_filter_index(tuple_list[i].filter);
        bool &= check_filter_availability(filter_index, tuple_list[i].number);
    }
    return bool;
}

void exec_filter(int index_number_process) {
    int child_pid;
    if ((child_pid = fork()) == 0) {
        int status;
        int index =
            get_filter_index(processes[index_number_process].filters_names[0]);
        filters[index].running++;
        char filter_path[64];

        int input_fd = open(processes[index_number_process].input, O_RDONLY);
        dup2(input_fd, 0);
        close(input_fd);

        int output_fd = open(processes[index_number_process].output,
                             O_CREAT | O_WRONLY, 0666);
        dup2(output_fd, 1);
        close(output_fd);

        strcpy(filter_path, filters_folder);
        strcat(filter_path, filters[index].bin);

        if (fork() == 0) {
            execl(filter_path, filter_path, NULL);
        } else {
            wait(&status);
            kill(getppid(), SIGUSR1);
        }
        _exit(EXIT_SUCCESS);
    } else {
        processes[index_number_process].fork_pid = child_pid;
    }
}

void exec_filters(int index_number_process) {
    int child_pid;
    int number_filters = processes[index_number_process].number_filters;
    if ((child_pid = fork()) == 0) {
        int status;
        int fildes[number_filters - 1][2];
        int index, i, j;
        for (i = 0; i < number_filters - 1; i++) pipe(fildes[i]);
        char filter_path[64];
        for (i = 0; i < number_filters; i++) {
            if (i == 0) {
                if (fork() == 0) {
                    index = get_filter_index(
                        processes[index_number_process].filters_names[i]);
                    for (j = 1; j < number_filters - 1; j++) {
                        close(fildes[j][0]);
                        close(fildes[j][1]);
                    }
                    close(fildes[0][0]);

                    int input_fd =
                        open(processes[index_number_process].input, O_RDONLY);
                    dup2(input_fd, 0);
                    close(input_fd);

                    dup2(fildes[0][1], 1);
                    close(fildes[0][1]);

                    strcpy(filter_path, filters_folder);
                    strcat(filter_path, filters[index].bin);

                    execl(filter_path, filter_path, NULL);
                    _exit(EXIT_FAILURE);
                }
            } else if (i == number_filters - 1) {
                if (fork() == 0) {
                    index = get_filter_index(
                        processes[index_number_process].filters_names[i]);
                    for (j = 0; j < number_filters - 2; j++) {
                        close(fildes[j][0]);
                        close(fildes[j][1]);
                    }
                    close(fildes[i - 1][1]);

                    dup2(fildes[i - 1][0], 0);
                    close(fildes[i - 1][0]);

                    int output_fd = open(processes[index_number_process].output,
                                         O_CREAT | O_WRONLY, 0666);
                    dup2(output_fd, 1);
                    close(output_fd);

                    strcpy(filter_path, filters_folder);
                    strcat(filter_path, filters[index].bin);
                    if (fork() == 0) {
                        execl(filter_path, filter_path, NULL);
                    } else {
                        wait(&status);
                        kill(server_pid, SIGUSR1);
                    }
                    _exit(EXIT_FAILURE);
                }
            } else {
                if (fork() == 0) {
                    index = get_filter_index(
                        processes[index_number_process].filters_names[i]);
                    for (j = 0; j < number_filters - 1; j++) {
                        if (j != i - 1 && j != i) {
                            close(fildes[j][0]);
                            close(fildes[j][1]);
                        }
                    }

                    close(fildes[i - 1][1]);
                    dup2(fildes[i - 1][0], 0);
                    close(fildes[i - 1][0]);

                    close(fildes[i][0]);
                    dup2(fildes[i][1], 1);
                    close(fildes[i][1]);

                    strcpy(filter_path, filters_folder);
                    strcat(filter_path, filters[index].bin);
                    execl(filter_path, filter_path, NULL);
                    _exit(EXIT_FAILURE);
                }
            }
        }
        _exit(EXIT_SUCCESS);
    } else {
        processes[index_number_process].fork_pid = child_pid;
    }
}

void reserve_filters(Tuple tuple_list[64], int tuple_list_size) {
    int i;
    for (i = 0; i < tuple_list_size; i++) {
        int filter_index = get_filter_index(tuple_list[i].filter);
        filters[filter_index].running += tuple_list[i].number;
    }
}

void processing() {
    int i, j;
    for (i = 0; queue_total_size > 0 && i < available_filters; i++) {
        for (j = 0; j < queue_size[i]; j++) {
            if (process_queue[i][j].inqueue) {
                if (check_filters_availability(
                        process_queue[i][j].tuple_list,
                        process_queue[i][j].tuple_list_size)) {
                    reserve_filters(process_queue[i][j].tuple_list,
                                    process_queue[i][j].tuple_list_size);
                    available_filters -= process_queue[i][j].number_filters;
                    process_queue[i][j].inqueue = 0;
                    queue_total_size--;
                    Process process = process_queue[i][j];
                    process.active = 1;
                    processes[number_processes++] = process;
                    send_message("processing\n",
                                 processes[number_processes - 1].client_pid, 0);
                    if (i == 0) {
                        exec_filter(number_processes - 1);
                    } else {
                        exec_filters(number_processes - 1);
                    }
                }
            }
        }
    }
}

int merge(char filters_names[64][64], int number_filters,
          Tuple tuple_list[64]) {
    int tuple_list_size = 1;
    int insert = 0;
    int i, j;
    strcpy(tuple_list[0].filter, filters_names[0]);
    tuple_list[0].number = 1;
    for (i = 1; i < number_filters; i++) {
        insert = 0;
        for (j = 0; !insert && j < tuple_list_size; j++) {
            if (strcmp(tuple_list[j].filter, filters_names[i]) == 0) {
                tuple_list[j].number++;
                insert++;
            }
        }
        if(!insert){
            tuple_list[tuple_list_size].number = 1;
            strcpy(tuple_list[tuple_list_size++].filter,filters_names[i]);
        }
    }
    return tuple_list_size;
}

void close_handler(int signum) {
    while(queue_total_size > 0){
        processing();
    }
    unlink(CLIENT_TO_SERVER_FIFO);
    exit(0);
}

void sigusr1_handler(int signum) {
    int status;
    int pid = wait(&status);

    int i, j;
    for (i = 0; i < number_processes; i++)
        if (processes[i].fork_pid == pid) break;
    processes[i].active = 0;
    for (j = 0; j < processes[i].number_filters; j++) {
        int index = get_filter_index(processes[i].filters_names[j]);
        filters[index].running--;
        available_filters++;
    }
    send_message("processed\n", processes[i].client_pid, 1);
    processing();
}

int main(int argc, char* argv[]) {
    server_pid = getpid();
    strcpy(filters_folder, argv[2]);

    // Set handlers for signals
    signal(SIGINT, close_handler);
    signal(SIGTERM, close_handler);
    signal(SIGUSR1, sigusr1_handler);

    read_config_file(argv[1]);
    if (mkfifo(CLIENT_TO_SERVER_FIFO, 0666) == -1) {
        /* ERROR */
        return 1;
    }

    Request request;
    while (1) {
        int client_to_server_fifo = open(CLIENT_TO_SERVER_FIFO, O_RDONLY, 0666);
        while (read(client_to_server_fifo, &request, sizeof(Request)) > 0) {
            if (request.argc > 3 && strcmp("transform", request.argv[0]) == 0) {
                send_message("pending\n", request.pid, 0);
                char filters_names[64][64];
                int i, faulty_filter_index;
                for (i = 3; i < request.argc; i++)
                    strcpy(filters_names[i - 3], request.argv[i]);
                if (valid_filters(filters_names, request.argc - 3,
                                  &faulty_filter_index)) {
                    Tuple tuple_list[64];
                    int tuple_list_size =
                        merge(filters_names, request.argc - 3, tuple_list);
                    if (check_filters_impossibility(tuple_list,
                                                    tuple_list_size)) {
                        send_message(
                            "this request can not be fullfilled by the "
                            "server in accordance with current config "
                            "file\n",
                            request.pid, 1);
                    } else {
                        Process process;
                        int i;
                        for (i = 3; i < request.argc; i++) {
                            strcpy(process.filters_names[i - 3],
                                   request.argv[i]);
                        }
                        process.number_filters = request.argc - 3;
                        process.client_pid = request.pid;
                        process.active = 0;
                        process.inqueue = 1;
                        queue_total_size++;
                        strcpy(process.input, request.argv[1]);
                        strcpy(process.output, request.argv[2]);
                        process.tuple_list_size = tuple_list_size;
                        for (i = 0; i < process.tuple_list_size; i++)
                            process.tuple_list[i] = tuple_list[i];
                        if (process.number_filters <= 15) {
                            process_queue[process.number_filters - 1]
                                         [queue_size[process.number_filters -
                                                     1]++] = process;
                        } else {
                            process_queue[15][queue_size[15]++] = process;
                        }
                        processing();
                    }
                } else {
                    char message[1024];
                    sprintf(message, "invalid filter: %s\n",
                            request.argv[faulty_filter_index + 3]);
                    send_message(message, request.pid, 1);
                }
            } else if (request.argc == 1 &&
                       strcmp("status", request.argv[0]) == 0) {
                send_status(request.pid);
            }
        }
        close(client_to_server_fifo);
    }

    return 0;
}

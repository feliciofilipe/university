#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define CLIENT_TO_SERVER_FIFO "tmp/client_to_server_fifo"

#include "../includes/request.h"
#include "../includes/response.h"

char server_to_client_fifo_name[128];

void make_request(int fd, char** argv, int argc) {
    Request request;
    request.argc = argc - 1;
    request.pid = getpid();
    int i;
    for (i = 1; i < argc; i++) strcpy(request.argv[i - 1], argv[i]);
    write(fd, &request, sizeof(Request));
}

void response() {
    Response response;
    int server_to_client_fifo = open(server_to_client_fifo_name, O_RDONLY);
    while (1) {
        while (read(server_to_client_fifo, &response, sizeof(Response)) > 0) {
            int i;
            for (i = 0; i < response.argc; i++)
                write(1, response.argv[i], strlen(response.argv[i]));
            if (response.flag) {
                close(server_to_client_fifo);
                exit(0);
            }
        }
    }
    close(server_to_client_fifo);
}

void close_handler(int signum) {
    unlink(server_to_client_fifo_name);
    exit(0);
}

int main(int argc, char** argv) {

    signal(SIGINT, close_handler);
    signal(SIGTERM, close_handler);

    sprintf(server_to_client_fifo_name, "tmp/%d", (int)getpid());

    if ((mkfifo(server_to_client_fifo_name, 0666)) == -1) {
        // write(fd_errors, "ERROR: Já existe fifo\n", 24);
    }

    if (argc > 1) {
        if ((strcmp(argv[1], "transform") == 0) ||
            (strcmp(argv[1], "status") == 0)) {
            if ((strcmp(argv[1], "transform") == 0) && argc < 5) {
                char invalid_transform[256];
                int invalid_transform_size = sprintf(
                    invalid_transform, "aurras: invalid transform command\n");
                write(1, invalid_transform, invalid_transform_size);
                return 0;
            } else if ((strcmp(argv[1], "status") == 0) && argc > 2) {
                char invalid_status[256];
                int invalid_status_size =
                    sprintf(invalid_status, "aurras: invalid status command\n");
                write(1, invalid_status, invalid_status_size);
                return 0;
            }
            int client_to_server_fifo = open(CLIENT_TO_SERVER_FIFO, O_WRONLY);
            make_request(client_to_server_fifo, argv, argc);
            close(client_to_server_fifo);
            response();
        } else {
            char command_not_found[256];
            int command_not_found_size = sprintf(
                command_not_found, "aurras: command not found: %s\n", argv[1]);
            write(1, command_not_found, command_not_found_size);
        }
    } else {
        char command1[128];
        char command2[128];
        int command1_size = sprintf(command1, "%s status\n", argv[0]);
        int command2_size =
            sprintf(command2,
                    "%s transform input-filename output-filename filter-id-1 "
                    "filter-id-2 ...\n",
                    argv[0]);
        write(1, command1, command1_size);
        write(1, command2, command2_size);
    }

    return 0;
}

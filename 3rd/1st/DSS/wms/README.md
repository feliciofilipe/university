[filipe]: https://github.com/feliciofilipe
[filipe-pic]: https://github.com/feliciofilipe.png?size=120
[luis]: https://github.com/LAraujo7
[luis-pic]: https://github.com/LAraujo7.png?size=120
[henrique]: https://github.com/henriq350
[henrique-pic]: https://github.com/henriq350.png?size=120
[paulo]: https://github.com/JohnBarros21
[paulo-pic]: https://github.com/JohnBarros21.png?size=120
[ruben]: https://github.com/rubenadao
[ruben-pic]: https://github.com/rubenadao.png?size=120

# WMS - Warehouse Management System

This project is a Warehouse Managment System in Java, with a beautiful GUI in JavaFX, capable of managing an robot automated warehouse with multiple different users at the same time - using an online database. Additionally we built a Web App capable of requesting Orders to the warehouse coded in JavaScript. Like in previous Java projects we made a terminal shell (now its used more as a development tool to quickly test queries and debug) that is generated automatically from the model source code using abstraction and reflections.

#### :star: (18/20) Best Group Project Grade in this Class (2020/2021).

## :camera: Screenshots

![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/0.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/1.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/2.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/3.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/4.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/5.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/6.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/7.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/8.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/9.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/10.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/12.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/13.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/14.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/15.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/16.PNG "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/17.png "Screenshot")
![alt text](https://github.com/feliciofilipe/university/raw/master/3rd/1st/DSS/wms/screenshots/18.png "Screenshot")



## :rocket: Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

Start by filling out the environment variables defined in the `.env` file. Use
the `.env.sample` as a starting point.

```bash
bin/setup
```

After this, you must fill in the fields correctly and export them in your
environment. Checkout [direnv](https://direnv.net/) for your shell and
[EnvFile](https://github.com/Ashald/EnvFile) for IntelliJ.

### :inbox_tray: Prerequisites

The following software is required to be installed on your system:

- [Java SDK 11](https://openjdk.java.net/)
- [Maven](https://maven.apache.org/maven-features.html)

### :hammer: Development

Start a server instance.

```
bin/server
```

Start a client instance.

```
bin/client
```

Run the project.

```
bin/run
```

Build the project.

```
bin/build
```

Run the tests.

```
bin/test
```

Format the code accordingly to common [guide lines](https://github.com/google/google-java-format).

```
bin/format
```

Lint your code with _checkstyle_.

```
bin/lint
```

Generate the documentation.

```
bin/docs
```

Clean the repository.

```
bin/clean
```

### :whale: Docker

If you want to setup the required databases using docker containers you can
easily do it with [docker-compose](https://docs.docker.com/compose/install/).

Create and start the containers.

```
docker-compose up
```

Start the previously created containers.

```
docker-compose start
```

Stop the containers.

```
docker-compose stop
```

Destroy the containers created.

```
docker-compose down
```

### :package: Deployment

Deploy the application.

```
bin/deploy
```

## :busts_in_silhouette: Team

| [![Filipe][filipe-pic]][filipe] | [![Henrique][henrique]][henrique] | [![Luís][luis-pic]][luis] | [![Paulo][paulo]][paulo] | [![Ruben][ruben-pic]][ruben] | 
| :-----------------------: | :-----------------------------: | :--------------------------: | :--------------------------: | :--------------------------: |
|   [Filipe Felício][filipe]   |    [Henrique Ribeiro][henrique]     |    [Luís Araújo][luis]    |    [Paulo Barros][paulo]    |    [Ruben Adao][ruben]    |

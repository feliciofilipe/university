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


Killing Floor Dedicated Server using Docker Compose
=====
This example defines a basic set up for a Killing Floor Dedicated Server using Docker Compose. 

## Project structure
```shell
.
├── docker-compose-rs.yml
├── docker-compose.yml
├── kfrs.env
├── kfserver.env
├── README.md
├── secret_steamacc_password.txt
└── secret_steamacc_username.txt
```

## [Compose file](docker-compose.yml)
```yaml
services:
  kfserver:
    image: k4rian/killingfloor:latest
    container_name: kfserver
    hostname: kfserver
    volumes:
      - data:/home/steam
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - kfserver.env
    secrets:
      - steamacc_username
      - steamacc_password
    ports:
      - 7707:7707/udp
      - 7708:7708/udp
      - 28852:28852/udp
      - 28852:28852/tcp
      - 8075:8075/tcp
      - 20560:20560/tcp
      - 20560:20560/udp
    restart: unless-stopped

volumes:
  data:

secrets:
  steamacc_username:
    file: ./secret_steamacc_username.txt
  steamacc_password:
    file: ./secret_steamacc_password.txt
```
* The environment file *[kfserver.env](kfserver.env)* holds the Dedicated Server environment variables.

* The Steam account username is defined in the *[secret_steamacc_username.txt](secret_steamacc_username.txt)* file. The secret name must be `steamacc_username`.

* The Steam account password is defined in the *[secret_steamacc_password.txt](secret_steamacc_password.txt)* file. The secret name must be `steamacc_password`.

## [Compose file](docker-compose-rs.yml) with [KFRS][1] (Redirect Server)
```yaml
services:
  kfserver:
    image: k4rian/killingfloor:latest
    container_name: kfserver
    hostname: kfserver
    volumes:
      - data:/home/steam
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - kfserver.env
    secrets:
      - steamacc_username
      - steamacc_password
    ports:
      - 7707:7707/udp
      - 7708:7708/udp
      - 28852:28852/udp
      - 28852:28852/tcp
      - 8075:8075/tcp
      - 20560:20560/tcp
      - 20560:20560/udp
    restart: unless-stopped
  
  kfrs:
    image: k4rian/kfrs:latest
    container_name: kfredirect
    hostname: kfredirect
    volumes:
      - files:/home/kfrs/redirect
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - kfrs.env
    ports:
      - 9090:9090/tcp
    restart: unless-stopped
    depends_on:
      kfserver:
        condition: service_started

volumes:
  data:
  files:

secrets:
  steamacc_username:
    file: ./secret_steamacc_username.txt
  steamacc_password:
    file: ./secret_steamacc_password.txt
```
* The environment file *[kfrs.env](kfrs.env)* holds the Redirect Server environment variables.

## Deployment
```bash
docker compose -p kfserver up -d
```
or
```bash
docker compose up -d -f docker-compose-rs.yml
```
> The project uses one or more volumes to store data that can be recovered if one or more containers are removed and restarted.

## Expected result
Check that the main container is running properly:
```bash
docker ps | grep "kfserver"
```

To see the server log output:
```bash
docker compose -p kfserver logs
```

## Stop the containers
Stop and remove the containers:
```bash
docker compose down
```

Both the containers and their volumes can be removed by providing the `-v` argument:
```bash
docker compose down -v
```

[1]: https://github.com/K4rian/kfrs "Killing Floor Redirect Server (KFRS)"
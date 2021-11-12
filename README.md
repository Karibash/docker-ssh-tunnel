# ssh-tunnel

This is a lightweight Docker image that creates a simple SSH tunnel using autossh on a server.
It is useful when you need to connect to an external, protected server.

## Usage

First, you need to write the ssh configuration in the local directory `~/.ssh/config`.
An example of the configuration is shown below.

```
Host tunnel-server # You can use any name you like
  HostName ssh-tunnel.test # Host name of the tunnel server
  User username # The user name to use for the ssh connection
  IdentityFile ~/.ssh/id_rsa # Private key location
```

The following is an example of `docker-compose.yml` for tunneling to multiple database servers.

```
version: '3'

networks:
  network_link:
    external: true

services:
  mysql-tunnel:
    image: karibash/ssh-tunnel
    container_name: mysql-tunnel
    ports:
      - 3306:3306
    networks:
      - network_link
    volumes:
      - ${HOME}/.ssh:/root/.ssh
      - type: bind
        source: /run/host-services/ssh-auth.sock
        target: /run/host-services/ssh-auth.sock
    environment:
      - SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
      - TUNNEL_ENV_PREFIX=MY_SQL
      - MY_SQL_TUNNEL_EXPOSE_PORT=3306
      - MY_SQL_TUNNEL_DESTINATION_HOST=mysql-server.test
      - MY_SQL_TUNNEL_DESTINATION_PORT=3306
      - MY_SQL_TUNNEL_SERVER_HOST_NAME=tunnel-server

  postgres-tunnel:
    image: karibash/ssh-tunnel
    container_name: postgres-tunnel
    ports:
      - 5432:5432
    networks:
      - network_link
    volumes:
      - ${HOME}/.ssh:/root/.ssh
      - type: bind
        source: /run/host-services/ssh-auth.sock
        target: /run/host-services/ssh-auth.sock
    environment:
      - SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
      - TUNNEL_ENV_PREFIX=POSTGRES
      - POSTGRES_TUNNEL_EXPOSE_PORT=5432
      - POSTGRES_TUNNEL_DESTINATION_HOST=postgres-server.test
      - POSTGRES_TUNNEL_DESTINATION_PORT=5432
      - POSTGRES_TUNNEL_SERVER_HOST_NAME=tunnel-server
```

Finally, you can start the server by using the `docker-compose up -d` command.

# Mochi-Margo Workspace

This provides a four-node virtual cluster by docker to develop
distributed systems in Mochi-Margo.

Container hostnames are c1, c2, c3, and c4.
The workspace in a container is ~/workspace,
which is shared among all containers.

This directory also includes sample programs in Mochi-Margo.

## Prerequisites for Windows

Install WSL
- https://learn.microsoft.com/en-us/windows/wsl/install

Install Docker Engine
- https://docs.docker.com/engine/install/ubuntu/

## Execute docker containers by Docker Engine

    $ docker compose up -d

You can login to a container as follows

    $ docker exec -it mochi-c1 bash
    $ cd

or

    $ ssh $(docker exec mochi-c1 hostname -i)

## Execute docker containers by VS Code dev containers

- Install VS Code and Remote Containers extension
- Open this directory
- Open a command palette by Ctrl+Shift+P and execute "Remote-Containers: Rebulid and Reopen in Container"

## Login to other containers in a container

    $ ssh c2

## Install new packages in a container

    $ sudo apt-get update
    $ sudo apt-get install ...

or modify Dockerfile

Enjoy!

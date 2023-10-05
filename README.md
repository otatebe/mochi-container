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

## Prerequisities

Install Docker Engine
- https://docs.docker.com/engine/install/ubuntu/ (for Ubuntu)
- https://docs.docker.com/engine/install/centos/ (for CentOS)

## Execute docker containers by Docker Engine and login to a container

    $ make

or

    $ docker compose build --build-arg UID=$(shell id -u) c1
    $ docker compose up -d
    $ docker exec -u ${USER} -w /home/${USER}/workspace -it mochi-c1 bash

## Execute docker containers by VS Code dev containers and login to a container

- Install VS Code and Remote Containers extension
- Open this directory
- Open a command palette by Ctrl+Shift+P and execute "Remote-Containers: Rebulid and Reopen in Container"

## Sample program

There is a sample program in Mochi-margo in the sample directory.  See [README](./sample/README.md) for details.

## Login to other containers in a container

    $ ssh c2

## Install new packages in a container

    $ sudo apt-get update
    $ sudo apt-get install ...

or modify Dockerfile

## Stop containers

    (in a host)
    $ make down

or

    $ docker compose down

Enjoy!

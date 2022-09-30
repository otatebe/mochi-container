# Mochi-Margo Workspace

This provides a four-node virtual cluster by docker to develop
distributed systems in Mochi-Margo.

There are four containers; c1, c2, c3, and c4.
The workspace in a container is ~/workspace,
which is shared among all containers.

This directory also includes sample programs in Mochi-Margo, and CMakeLists.txt.

## Prerequisites for Windows

Install WSL
- https://learn.microsoft.com/en-us/windows/wsl/install

Install Docker Engine
- https://docs.docker.com/engine/install/ubuntu/

## Execute docker containers by Docker Engine

    $ docker compose up -d

You can login to a container as follows

    $ docker exec -it c1 bash
    $ cd

or

    $ ssh $(docker exec -it c1 hostname -i)

## Execute docker containers by VS Code dev containers

- Install VS Code and Remote Containers extension
- Open this directory
- Open a command palette by Ctrl+Shift+P and execute "Remote-Containers: Rebulid and Reopen in Container"

## How to compile sample programs in ~/workspace

    $ cd sample
    $ mkdir build
    $ cd build
    $ spack load mochi-margo
    $ cmake -DCMAKE_INSTALL_PREFIX=$HOME/workspace ..
    $ make
    $ make install

Target programs; server and client, are installed in ~/workspace/bin, which is shared among containers.  This directory is included in PATH environment variable by ~/.bashrc.

## Execute a server

    $ server
    Server running at address na+sm://6564-0

## Execute a client
Specify the server address, key and value

    $ client na+sm://6564-0 111 222

## Login to other containers in a container

    $ ssh c2

Enjoy!

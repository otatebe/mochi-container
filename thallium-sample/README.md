# Sample program

This is a sample program in Mochi-thallium.  This makes the following local function to a remote procedure call.
```
int
put(const char *key, const char *value)
{
    printf("put: key %s, value %s\n", key, value);
    return (0);
}
```
# How to compile sample programs

    $ mkdir build
    $ cd build
    $ spack load mochi-thallium
    $ cmake -DCMAKE_INSTALL_PREFIX=$HOME/workspace ..
    $ make
    $ make install

Target programs; server and client, are installed in ~/workspace/bin, which is shared among containers.  This directory is included in PATH environment variable by ~/.bashrc.

# Execute a server

    $ server
    Server running at address na+sm://6564-0

# Execute a client
Specify the server address, key and value

    $ client na+sm://6564-0 111 222

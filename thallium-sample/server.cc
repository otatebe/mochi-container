#include <iostream>
#include <thallium.hpp>
#include <thallium/serialization/stl/string.hpp>

namespace tl = thallium;

void put(const tl::request &req, std::string key, std::string value)
{
    printf("put: key %s, value %s\n", key.c_str(), value.c_str());
    req.respond(0);
}

int main(int argc, char **argv)
{
    tl::engine myEngine("na+sm", THALLIUM_SERVER_MODE);
    std::cout << "Server running at address " << myEngine.self() << std::endl;
    myEngine.define("put", put);
    return 0;
}

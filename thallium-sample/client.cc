#include <iostream>
#include <thallium.hpp>
#include <thallium/serialization/stl/string.hpp>

namespace tl = thallium;

int main(int argc, char **argv)
{
    tl::engine myEngine("tcp", THALLIUM_CLIENT_MODE);
    tl::remote_procedure put = myEngine.define("put");
    tl::endpoint server = myEngine.lookup(argv[1]);
    std::string key = argv[2];
    std::string value = argv[3];
    int ret;
    ret = put.on(server)(key, value);
    std::cout << "ret=" << ret << std::endl;
    return 0;
}

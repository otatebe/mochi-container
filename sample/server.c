#include <assert.h>
#include <stdio.h>
#include <margo.h>
#include "types.h"

static void put(hg_handle_t h);
DECLARE_MARGO_RPC_HANDLER(put)

int
main(int argc, char *argv[])
{
	margo_instance_id mid;
	char addr_str[PATH_MAX];
	size_t addr_str_size = sizeof(addr_str);
	hg_addr_t my_address;

	mid = margo_init("tcp", MARGO_SERVER_MODE, 0, 0);
	assert(mid);

	margo_addr_self(mid, &my_address);
	margo_addr_to_string(mid, addr_str, &addr_str_size, my_address);
	margo_addr_free(mid, my_address);
	printf("Server running at address %s\n", addr_str);

	MARGO_REGISTER(mid, "put", put_in_t, int32_t, put);

	margo_wait_for_finalize(mid);

	return (0);
}

static void
put(hg_handle_t h)
{
	hg_return_t ret;
	put_in_t in;
	int32_t out;

	ret = margo_get_input(h, &in);
	if (ret != HG_SUCCESS) {
		fprintf(stderr, "put (get_input): %s\n",
				HG_Error_to_string(ret));
		goto destroy;
	}
	printf("put: key %s, value %s\n", in.key, in.value);
	out = 0;

	ret = margo_free_input(h, &in);
	if (ret != HG_SUCCESS)
		fprintf(stderr, "put (free_input): %s\n",
				HG_Error_to_string(ret));

	ret = margo_respond(h, &out);
	if (ret != HG_SUCCESS)
		fprintf(stderr, "put (respond): %s\n", HG_Error_to_string(ret));

destroy:
	ret = margo_destroy(h);
	if (ret != HG_SUCCESS)
		fprintf(stderr, "put (destroy): %s\n", HG_Error_to_string(ret));
}
DEFINE_MARGO_RPC_HANDLER(put)

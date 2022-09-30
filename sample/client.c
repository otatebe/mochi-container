#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <margo.h>
#include "types.h"

static struct {
	margo_instance_id mid;
	hg_addr_t serv_addr;
	hg_id_t put_rpc;
} env;

static hg_return_t
call_put(const char *key, const char *value)
{
	hg_handle_t h;
	hg_return_t ret, ret2;
	put_in_t in;
	int32_t out;

	ret = margo_create(env.mid, env.serv_addr, env.put_rpc, &h);
	if (ret != HG_SUCCESS) {
		fprintf(stderr, "call_put (create): %s\n",
				HG_Error_to_string(ret));
		return (ret);
	}
	in.key = key;
	in.value = value;
	ret = margo_forward(h, &in);
	if (ret != HG_SUCCESS) {
		fprintf(stderr, "call_put (forward): %s\n",
				HG_Error_to_string(ret));
		goto err;
	}

	ret = margo_get_output(h, &out);
	if (ret != HG_SUCCESS) {
		fprintf(stderr, "call_put (output): %s\n",
				HG_Error_to_string(ret));
		goto err;
	}
	printf("out %d\n", out);
	ret = margo_free_output(h, &out);
err:
	ret2 = margo_destroy(h);
	if (ret == HG_SUCCESS)
		ret = ret2;
	return (ret);
}

static void
init(const char *server)
{
	hg_return_t ret;

	env.mid = margo_init("tcp", MARGO_CLIENT_MODE, 0, 0);
	assert(env.mid);

	ret = margo_addr_lookup(env.mid, server, &env.serv_addr);
	if (ret != HG_SUCCESS)
		fprintf(stderr, "%s: %s, abort\n", server,
		    HG_Error_to_string(ret)), exit(1);
	env.put_rpc = MARGO_REGISTER(env.mid, "put", put_in_t, int32_t, NULL);
}

int
main(int argc, char *argv[])
{
	if (argc != 4)
		fprintf(stderr, "usage: %s server key value\n", argv[0]),
			exit(1);
	init(argv[1]);
	call_put(argv[2], argv[3]);
	return (0);
}

#include <mercury.h>
#include <mercury_macros.h>
#include <mercury_proc_string.h>

MERCURY_GEN_PROC(put_in_t,
	((hg_const_string_t)(key))\
	((hg_const_string_t)(value)))

/* Copyright (C) 2001-2020 Artifex Software, Inc.
   All Rights Reserved.

   This software is provided AS-IS with no warranty, either express or
   implied.

   This software is distributed under license and may not be copied,
   modified or distributed except as expressly authorized under the terms
   of the license contained in the file LICENSE in this distribution.

   Refer to licensing information at http://www.artifex.com or contact
   Artifex Software, Inc.,  1305 Grant Avenue - Suite 200, Novato,
   CA 94945, U.S.A., +1(415)492-9861, for further information.
*/


/* Implementation definitions for zlib interface */
/* Must be compiled with -I$(ZSRCDIR) */

#ifndef szlibxx_INCLUDED
#  define szlibxx_INCLUDED

#include "szlibx.h"
#include "zlib.h"

/*
 * We don't want to allocate zlib's private data directly from
 * the C heap, but we must allocate it as immovable; and to avoid
 * garbage collection issues, we must keep GC-traceable pointers
 * to every block allocated.  Since the stream state itself is movable,
 * we have to allocate an immovable block for the z_stream state as well.
 */
typedef struct zlib_block_s zlib_block_t;
struct zlib_block_s {
    void *data;
    zlib_block_t *next;
    zlib_block_t *prev;
};
#define private_st_zlib_block()	/* in szlibc.c */\
  gs_private_st_ptrs3(st_zlib_block, zlib_block_t, "zlib_block_t",\
    zlib_block_enum_ptrs, zlib_block_reloc_ptrs, next, prev, data)
/* The typedef is in szlibx.h */
/*typedef*/ struct zlib_dynamic_state_s {
    gs_memory_t *memory;
    zlib_block_t *blocks;
    z_stream zstate;
} /*zlib_dynamic_state_t*/;
#define private_st_zlib_dynamic_state()	/* in szlibc.c */\
  gs_private_st_ptrs1(st_zlib_dynamic_state, zlib_dynamic_state_t,\
    "zlib_dynamic_state_t", zlib_dynamic_enum_ptrs, zlib_dynamic_reloc_ptrs,\
    blocks)

/*
 * Provide zlib-compatible allocation and freeing functions.
 * The mem pointer actually points to the dynamic state.
 */
void *s_zlib_alloc(void *mem, uint items, uint size);
void s_zlib_free(void *mem, void *address);

/* Internal procedure to allocate and free the dynamic state. */
int s_zlib_alloc_dynamic_state(stream_zlib_state *ss);
void s_zlib_free_dynamic_state(stream_zlib_state *ss);

#endif /* szlibxx_INCLUDED */

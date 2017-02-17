px4_add_module(
	MODULE lib__c-ringbuf
	COMPILE_FLAGS
    -O0 -g -Wall
	SRCS
		ringbuf.c
 DEPENDS
   platforms__common
	)


/**************************************************************************
iPXE -  Network Bootstrap Program

Literature dealing with the network protocols:
	ARP - RFC826
	RARP - RFC903
	UDP - RFC768
	BOOTP - RFC951, RFC2132 (vendor extensions)
	DHCP - RFC2131, RFC2132 (options)
	TFTP - RFC1350, RFC2347 (options), RFC2348 (blocksize), RFC2349 (tsize)
	RPC - RFC1831, RFC1832 (XDR), RFC1833 (rpcbind/portmapper)

**************************************************************************/

FILE_LICENCE ( GPL2_OR_LATER_OR_UBDL );

#include <stddef.h>
#include <stdio.h>
#include <ipxe/init.h>
#include <ipxe/version.h>
#include <usr/autoboot.h>

/**
 * Main entry point
 *
 * @ret rc		Return status code
 */
__asmcall int main ( void ) {
	int rc;

	/* Perform one-time-only initialisation (e.g. heap) */
	initialise();

	/* Some devices take an unreasonably long time to initialise */
	printf ( "%s initialising devices...", product_short_name );
	startup();
	printf ( "ok\n" );

    printf ("\nBuilt by ISAAC");
    printf ("\n  1. Add CONSOLE_CMD in the shell.");
    printf ("\n  2. Enable COMBOOT for pcbios only.");
    printf ("\n  3. Restore the TPL to the original one.");

	/* Attempt to boot */
	if ( ( rc = ipxe ( NULL ) ) != 0 )
		goto err_ipxe;

 err_ipxe:
	shutdown_exit();
	return rc;
}

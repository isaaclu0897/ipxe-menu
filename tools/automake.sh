#!/bin/bash

ipxe_source_path="ipxe/src"
script_path="../../tools/script.ipxe"	# The path of script_path is relative to ipxe_source_path

echo make clean all
make -C $ipxe_source_path clean

echo start to make undionly.kpxe
make -C $ipxe_source_path -j 16 bin-x86_64-pcbios/undionly.kpxe EMBED=$script_path &> /dev/null && echo make undionly.kpxe successed || echo "failed to make undionly.kpxe"

echo start to make ipxe.efi and snponly.efi
make -C $ipxe_source_path -j 16 bin-x86_64-efi/{ipxe.efi,snponly.efi} EMBED=$script_path &> /dev/null && echo make ipxe.efi and snponly.efi successed || echo "failed to make ipxe.efi and snponly.efi"

echo link file

ln -snf $ipxe_source_path/bin-x86_64-pcbios/undionly.kpxe undionly.kpxe
ln -snf $ipxe_source_path/bin-x86_64-efi/ipxe.efi ipxe.efi
ln -snf $ipxe_source_path/bin-x86_64-efi/snponly.efi snponly.efi

echo done

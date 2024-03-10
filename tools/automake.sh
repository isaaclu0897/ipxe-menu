#!/bin/bash

ipxe_source_path="ipxe/src"

echo make clean all
make -C $ipxe_source_path clean
rm -rf $ipxe_source_path/bin*


echo start to make ipxe.pxe undionly.kpxe
make -C $ipxe_source_path -j 16 bin-x86_64-pcbios/{ipxe.pxe,undionly.kpxe} &> /dev/null && echo make pcbios successed || echo "failed to make pcbios"
echo copy file
cp $ipxe_source_path/bin-x86_64-pcbios/ipxe.pxe ipxe.pxe
cp $ipxe_source_path/bin-x86_64-pcbios/undionly.kpxe undionly.kpxe

echo start to make ipxe.efi and snponly.efi
make -C $ipxe_source_path -j 16 bin-x86_64-efi/{ipxe.efi,snponly.efi} &> /dev/null && echo make efi successed || echo "failed to make efi"
echo copy file
cp $ipxe_source_path/bin-x86_64-efi/ipxe.efi ipxe.efi
cp $ipxe_source_path/bin-x86_64-efi/snponly.efi snponly.efi

echo done

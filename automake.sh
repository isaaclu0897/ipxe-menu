#!/bin/bash

echo go to soruce foler

cd src

echo make clean all

make clean

echo make undionly.kpxe
make -j 16 bin-x86_64-pcbios/undionly.kpxe EMBED=../script.ipxe &> /dev/null && echo make undionly.kpxe successed || echo "failed to make undionly.kpxe"

echo make ipxe.efi and snponly.efi
make -j 16 bin-x86_64-efi/{ipxe.efi,snponly.efi} EMBED=../script.ipxe &> /dev/null && echo make ipxe.efi and snponly.efi successed || echo "failed to make ipxe.efi and snponly.efi"

echo back to folder

cd -

echo link file

ln -snf src/bin-x86_64-pcbios/undionly.kpxe undionly.kpxe
ln -snf src/bin-x86_64-efi/ipxe.efi ipxe.efi
ln -snf src/bin-x86_64-efi/snponly.efi snponly.efi

echo done

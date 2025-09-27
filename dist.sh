#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [[ $# -ne 3 ]]; then
    echo "Usage: ./dist.sh <CHANNEL> <TOOLCHAIN> <TARGET>"
    exit 1
fi

channel=$1
toolchain=$2
target=$3

pushd rust/build/dist

echo "Extracting distribution artifacts"
tar -xvf rust-std-$channel-$target.tar.gz
rm rust-std-$channel-$target.tar.gz

pushd rust-std-$channel-$target

echo "Modifying distribution artifacts"
mv install.sh rust-install.sh
HERMIT_TOOLCHAIN=$toolchain envsubst '$HERMIT_TOOLCHAIN' < ../../../../install-template.sh > install.sh
chmod +x install.sh

popd

echo "Compressing distribution artifacts"
tar -cavf rust-std-$channel-$target{.tar.gz,}

popd

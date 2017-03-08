#!/bin/bash

cd /share/apps
git clone https://github.com/llnl/spack.git

cat << EOF > /share/apps/spack/env.sh
export SPACK_ROOT=/share/apps/spack
source /share/apps/spack/share/spack/setup-env.sh
EOF

sed -i '/^modules:/a\
  tcl:\
    hash_length: 0' /share/apps/spack/etc/spack/defaults/modules.yaml


source /share/apps/spack/env.sh

# Install tar as proof of concept
FORCE_UNSAFE_CONFIGURE=1 spack install tar

module avail

#!/bin/bash -eux
echo ""
echo "Build GraalBasic, a Graal-enabled JDK"
echo ""

mkdir -p ~/.local
git clone https://github.com/smarr/GraalBasic.git
cd GraalBasic
git checkout d37bbe4de590087231cb17fb8e5e08153cd67a59

./build.sh
cd ..
export GRAAL_HOME=~/.local/graal-core
echo "" >> ~/.profile
echo "# Export GRAAL_HOME for Moth" >> ~/.profile
echo "export GRAAL_HOME=~/.local/graal-core" >> ~/.profile


git clone ${GIT_REPO} ${REPO_NAME}

cd ${REPO_NAME}
git checkout ${COMMIT_SHA}
git submodule update --init --recursive
rebench --faulty --setup-only ${REBENCH_CONF} all

cd ~/eval-description
make

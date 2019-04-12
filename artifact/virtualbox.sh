#!/bin/bash
set -e # make script fail on first error

# make SCRIPT_PATH absolute
pushd `dirname $0` > /dev/null
SCRIPT_PATH=`pwd`
popd > /dev/null

source ${SCRIPT_PATH}/../implementations/script.inc
source ${SCRIPT_PATH}/config.inc

## Make sure we have all dependencies
check_for "vagrant" "Vagrant does not seem available. This was tested with version 2.1.2 from https://www.vagrantup.com/downloads.html"

INFO Setup a Vagrant VM Image
pushd ${SCRIPT_PATH}

INFO "Get Paper Repository for Evaluation Material"
git clone --depth=1 ${PAPER_REPO} paper

vagrant up
vagrant halt
# --base ${BOX_NAME}
vagrant package --output ${BOX_NAME}.tar.gz
popd

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

function halt_and_remove_image {
  vagrant halt
  vagrant destroy -f
}
trap halt_and_remove_image EXIT

INFO "Get Paper Repository for Evaluation Material"
git clone --depth=1 ${PAPER_REPO} paper

tar cjvf eval.tar.bz2 paper/evaluation paper/eval-description
mv eval.tar.bz2 ~/artifacts/${BOX_NAME}-eval.tar.bz2

vagrant up
vagrant halt
# --base ${BOX_NAME}
vagrant package --output ${BOX_NAME}.tar.gz
mv ${BOX_NAME}.tar.gz ~/artifacts/

echo File Size
ls -sh ~/artifacts/${BOX_NAME}*

echo MD5
md5sum ~/artifacts/${BOX_NAME}*

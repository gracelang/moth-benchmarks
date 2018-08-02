#!/bin/bash
SCRIPT_PATH=`dirname $0`
source $SCRIPT_PATH/script.inc

pushd $SCRIPT_PATH/Higgs/source
./higgs "$@"; RET=${PIPESTATUS[0]}

if [ $RET != 0 ]
then
    exit 1
fi

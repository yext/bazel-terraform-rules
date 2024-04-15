#!/bin/bash

OUT=$(./tests/allow_provider_download/terraform plan -no-color)
if [ $? -ne 0 ];
then
    echo 'Plan failed';
    exit 1
fi

PASS=1

function expect_output() {
    if [[ "$OUT" != *"$1"* ]]; then
        echo "FAIL: Expected text '$1'"
        PASS=0
    fi   
}

expect_output "+ resource \"local_file\" \"foo\" {"
expect_output "1 to add"

if [[ $PASS == 0 ]]; then
    echo "$OUT"
    exit 1
fi
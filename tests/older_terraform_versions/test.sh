#!/bin/bash

OUT=$($1 plan -no-color)
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

expect_output "+ resource \"example_server\" \"my-server\" {"
expect_output "+ address = \"1.2.3.4\""
expect_output "1 to add"

if [[ $PASS == 0 ]]; then
    echo "$OUT"
    exit 1
fi
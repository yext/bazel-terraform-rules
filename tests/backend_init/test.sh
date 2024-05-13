#!/bin/bash

STATE_DIR=$(mktemp -d)

MODULE_DIR=./tests/backend_init/terraform_working/tests/backend_init

BACKEND_FILE="$MODULE_DIR/local_backend.tf"
cat > "$BACKEND_FILE" <<-EOF
terraform {
    backend "local" {
    path = "$STATE_DIR/terraform.tfstate"

    }
}
EOF

if [ -f $STATE_DIR/terraform.tfstate ]; then
    echo "Temp tfstate file should not exist before apply"
    exit 1
fi

OUT=$(./tests/backend_init/terraform apply -auto-approve -no-color)
if [ $? -ne 0 ];
then
    echo 'Apply failed';
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

if [[ $(cat $MODULE_DIR/foo.bar) != "hello, world" ]]; then
    echo "FAIL: content of generated file was not as expected"
    PASS=0
fi

if [[ $PASS == 0 ]]; then
    echo "$OUT"
    exit 1
fi

if [ ! -f $STATE_DIR/terraform.tfstate ]; then
    echo "Temp tfstate file should exist after apply"
    exit 1
fi
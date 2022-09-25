#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INSTALLATION_CODE=$1

PREAMBLE=$'workspace(name = "tf_modules_example")\n\n'

echo "$PREAMBLE$INSTALLATION_CODE" > $SCRIPT_DIR/../test/WORKSPACE

pushd $SCRIPT_DIR/../test
bazel build //...
popd
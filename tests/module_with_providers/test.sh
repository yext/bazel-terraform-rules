#!/bin/bash

OUT=$(./tests/module_with_providers/terraform plan -no-color)
if [ $? -ne 0 ];
then
    echo 'Plan failed';
    exit 1
fi

if [[ "$OUT" != *"+ address = \"1.2.3.4\""* ]]; then
  echo "Expected address to be 1.2.3.4:"
  echo $OUT
  exit 1
fi
if [[ "$OUT" != *"2 to add"* ]]; then
  echo "Expected resource count of 2:"
  echo $OUT
  exit 1
fi
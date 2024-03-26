#!/bin/bash

URL=$1
SHA=$2

cat << EndOfMessage
# Import http_archive if not already in use
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Add Terraform rules as repository
http_archive(
    name = "tf_modules",
    urls = ["$URL"],
    sha256 = "$SHA",
)
load("@tf_modules//terraform:versions.bzl", "register_terraform_version")

load("@tf_modules//:deps.bzl", "bazel_terraform_rules_deps")
bazel_terraform_rules_deps()

# Register required Terraform versions
register_terraform_version("1.2.3", default=True)
EndOfMessage
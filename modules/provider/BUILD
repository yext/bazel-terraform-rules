load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("@tf_modules//tools:def.bzl", "terraform_module")

terraform_module(
    name = "provider",
    terraform_executable = "@terraform_toolchain-0.12.24//:terraform_executable",
    ## TODO: Add source and version info to construct the right directory structure for 0.13 and up.
    provider_binaries = [":terraform-provider-example"]
)

exports_files(["terraform-provider-example"])
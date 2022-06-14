load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("@tf_modules//tools:def.bzl", "terraform_module")

terraform_module(
    name = "provider",
    terraform_executable = "@terraform_toolchain-0.12.24//:terraform_executable",
    ## Provider binaries will only work in 0.12.x and lower.
    provider_binaries = [":terraform-provider-example"]
)

exports_files(["terraform-provider-example"])
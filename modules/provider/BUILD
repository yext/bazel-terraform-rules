load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("@tf_modules//tools:def.bzl", "terraform_module")

terraform_module(
    name = "provider",
    #terraform_executable = "@terraform_toolchain-0.12.24//:terraform_executable",
    provider_binaries = [":terraform-provider-example"],
    provider_versions = {
        ":terraform-provider-example": "terraform.example.com/examplecorp/example/1.0.0",
    },
)

exports_files(["terraform-provider-example"])
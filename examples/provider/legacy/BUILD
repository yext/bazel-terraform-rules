load("@tf_modules//rules:module.bzl", "terraform_module")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")

terraform_working_directory(
    name = "terraform",
    module = ":provider_legacy",
    providers = [
        "//examples/provider/example_provider:provider_examplecorp_example",
        "@provider_hashicorp_local//:provider",
    ],
    terraform = "@terraform_toolchain-0.12.24//:terraform_executable",
)

terraform_module(
    name = "provider_legacy",
    srcs = ["main_legacy.tf"],
    visibility = ["//visibility:public"],
)

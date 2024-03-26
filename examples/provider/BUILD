load("@tf_modules//rules:module.bzl", "terraform_module")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")

terraform_module(
    name = "provider",
    srcs = ["main.tf"],
    visibility = ["//visibility:public"],
)

terraform_working_directory(
    name = "terraform",
    module = ":provider",
    providers = [
        "//examples/provider/example_provider:provider_examplecorp_example",
        "@provider_hashicorp_local//:provider",
    ],
)

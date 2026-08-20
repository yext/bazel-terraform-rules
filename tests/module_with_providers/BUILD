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
        "//tests/module_with_providers/example_provider",
        "@provider_hashicorp_local//:provider",
    ],
)

terraform_working_directory(
    name = "opentofu",
    module = ":provider",
    providers = [
        "//tests/module_with_providers/example_provider",
        "@provider_hashicorp_local//:provider",
    ],
    terraform = "@opentofu_default//:opentofu_executable",
)

sh_test(
    name = "terraform_test",
    size = "small",
    srcs = ["test.sh"],
    args = ["./tests/module_with_providers/terraform"],
    data = [":terraform"],
)

sh_test(
    name = "opentofu_test",
    size = "small",
    srcs = ["test.sh"],
    args = ["./tests/module_with_providers/opentofu"],
    data = [":opentofu"],
)

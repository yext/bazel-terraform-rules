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
    allow_provider_download = True,
)

terraform_working_directory(
    name = "opentofu",
    module = ":provider",
    allow_provider_download = True,
    terraform = "@opentofu_default//:opentofu_executable",
)

sh_test(
    name = "terraform_test",
    size = "small",
    srcs = ["test.sh"],
    args = ["./tests/allow_provider_download/terraform"],
    data = [":terraform"],
)

sh_test(
    name = "opentofu_test",
    size = "small",
    srcs = ["test.sh"],
    args = ["./tests/allow_provider_download/opentofu"],
    data = [":opentofu"],
)

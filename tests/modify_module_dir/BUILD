load("@tf_modules//rules:module.bzl", "terraform_module")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")
load(":test.bzl", "execute_test")

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

execute_test(
    name = "terraform_test",
    terraform_working_directory = ":terraform",
)

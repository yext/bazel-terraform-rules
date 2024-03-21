load("@tf_modules//rules:module.bzl", "terraform_module")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")

terraform_module(
    name = "vars",
    srcs = glob(["*.tf"]),
    visibility = ["//visibility:public"],
)

terraform_working_directory(
    name = "terraform",
    module = ":vars",
    tf_vars = {
        "test_input": "test_value"
    },
)

load("@tf_modules//:def.bzl", "terraform_module", "terraform_working_directory")

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

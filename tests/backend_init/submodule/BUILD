load("@tf_modules//rules:module.bzl", "terraform_module")

terraform_module(
    name = "submodule",
    srcs = glob(["*.tf"]),
    visibility = ["//visibility:public"],
)

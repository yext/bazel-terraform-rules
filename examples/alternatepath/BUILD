load("@tf_modules//rules:module.bzl", "terraform_module")

terraform_module(
    name = "alternatepath",
    srcs = glob(["*.tf"]),
    module_path = "./alternate/module/path",
    visibility = ["//visibility:public"],
)

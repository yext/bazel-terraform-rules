load("@tf_modules//rules:module.bzl", "terraform_module")

terraform_module(
    name = "multimodule",
    srcs = glob(["module1.tf"]),
    visibility = ["//visibility:public"],
)

terraform_module(
    name = "module2",
    srcs = glob(["module2.tf"]),
    visibility = ["//visibility:public"],
)

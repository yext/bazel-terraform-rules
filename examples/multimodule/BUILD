# load("@tf_modules//:def.bzl", "terraform_module")
load("@tf_modules//rules:module.bzl", "terraform_module")

terraform_module(
    name = "multimodule",
    srcs = ["module1.tf"],
    visibility = ["//visibility:public"],
)

terraform_module(
    name = "module2",
    srcs = ["module2.tf"],
    visibility = ["//visibility:public"],
)

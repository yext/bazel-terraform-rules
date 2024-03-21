load("@tf_modules//rules:module.bzl", "terraform_module")

terraform_module(
    name = "non_tf_sources",
    srcs = glob(["*.tf"]) + ["//examples/nested/non_tf_sources/data:fromsrc.txt"],
    srcs_flatten = ["//examples/nested/non_tf_sources/data:flatten.txt"],
    visibility = ["//visibility:public"]
)

load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "non_tf_sources",
    srcs = glob(["*.tf"]) + ["//modules/nested/non_tf_sources/data:fromsrc.txt"],
    srcs_flatten = ["//modules/nested/non_tf_sources/data:flatten.txt"]
)

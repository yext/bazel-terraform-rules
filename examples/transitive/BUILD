load("@tf_modules//rules:module.bzl", "terraform_module")

terraform_module(
    name = "transitive",
    srcs = glob(["*.tf"]),
    module_deps = [
        "//examples/nested/directories",
        "//examples/nested/non_tf_sources",
    ],
    visibility = ["//visibility:public"],
)

load("@tf_modules//rules:module.bzl", "terraform_module")

terraform_module(
    name = "transitive_relative",
    srcs = glob(["*.tf"]),
    absolute_module_source_paths = False,
    module_deps = [
        "//examples/nested/directories",
        "//examples/nested/non_tf_sources",
    ],
    visibility = ["//visibility:public"],
)

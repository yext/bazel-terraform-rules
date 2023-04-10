load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "transitive_relative",
    srcs = glob(["*.tf"]),
    absolute_module_source_paths = False,
    module_deps = [
        "//modules/nested/directories",
        "//modules/nested/non_tf_sources"
    ],
)

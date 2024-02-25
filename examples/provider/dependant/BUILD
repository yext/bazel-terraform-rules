load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "dependant",
    srcs = glob(["*.tf"]),
    module_deps = [
        "//examples/provider",
    ],
)

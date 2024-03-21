load("@tf_modules//rules:module.bzl", "terraform_module")

terraform_module(
    name = "dependant",
    srcs = glob(["*.tf"]),
    module_deps = [
        "//examples/provider",
    ],
)

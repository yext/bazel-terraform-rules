load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "dependant",
    srcs_tf = glob(["*.tf"]),
    module_deps = [
        "//modules/provider",
    ],
)

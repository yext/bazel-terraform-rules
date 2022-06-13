load("@tf_modules//tools:def.bzl", "terraform_module")

terraform_module(
    name = "consumer",
    deps = [
        "//modules/constants",
        "//modules/nested/directories",
    ],
    #terraform_executable = "@terraform_toolchain-0.12.24//:terraform_executable"
)

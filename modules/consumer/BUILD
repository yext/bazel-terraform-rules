load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "consumer",
    srcs = glob(["*.tf"]),
    module_deps = [
        "//modules/constants",
        "//modules/transitive",
        "//modules/alternatepath",
    ],
    terraform_executable = "@terraform_toolchain-0.12.24//:terraform_executable",
)

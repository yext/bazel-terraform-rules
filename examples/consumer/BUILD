load("@tf_modules//rules:module.bzl", "terraform_module")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")

terraform_module(
    name = "consumer",
    srcs = glob(["*.tf"]),
    module_deps = [
        "//examples/constants",
        "//examples/transitive",
        "//examples/transitive_relative",
        "//examples/alternatepath",
    ],
    visibility = ["//visibility:public"],
)

terraform_working_directory(
    name = "terraform",
    module = ":consumer",
    terraform = "@terraform_toolchain-0.12.24//:terraform_executable",
)

load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "consumer_relative",
    srcs = glob(["*.tf"]),
    absolute_module_source_paths = False,
    module_deps = [
        "//modules/constants",
        "//modules/transitive",
        "//modules/transitive_relative",
        "//modules/alternatepath",
    ],
    terraform_executable = "@terraform_toolchain-0.12.24//:terraform_executable",
)


# This is the same as the above, but with the alternate path to the module.
# This is to test that the module can be found in both locations.
terraform_module(
    name = "alternatepath",
    srcs = glob(["*.tf"]),
    absolute_module_source_paths = False,
    module_path = "./path/to/module",
    module_deps = [
        "//modules/constants",
        "//modules/transitive",
        "//modules/transitive_relative",
        "//modules/alternatepath",
    ],
    terraform_executable = "@terraform_toolchain-0.12.24//:terraform_executable",
)

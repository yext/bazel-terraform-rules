load("@tf_modules//:def.bzl", "terraform_module", "terraform_working_directory")

terraform_module(
    name = "consumer_relative",
    srcs = glob(["*.tf"]),
    absolute_module_source_paths = False,
    module_deps = [
        "//examples/constants",
        "//examples/transitive",
        "//examples/transitive_relative",
        "//examples/alternatepath",
    ],
    visibility = ["//visibility:public"],
)


# This is the same as the above, but with the alternate path to the module.
# This is to test that the module can be found in both locations.
terraform_module(
    name = "alternatepath",
    srcs = glob(["*.tf"]),
    absolute_module_source_paths = False,
    module_path = "./path/to/module",
    module_deps = [
        "//examples/constants",
        "//examples/transitive",
        "//examples/transitive_relative",
        "//examples/alternatepath",
    ],
    visibility = ["//visibility:public"],
)

terraform_working_directory(
    name="consumer_relative_terraform",
    module=":consumer_relative",
    terraform = "@terraform_toolchain-0.12.24//:terraform_executable",
)

terraform_working_directory(
    name="alternatepath_terraform",
    module=":alternatepath",
    terraform = "@terraform_toolchain-0.12.24//:terraform_executable",
)
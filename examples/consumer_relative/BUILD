load("@tf_modules//rules:module.bzl", "terraform_module")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")

terraform_module(
    name = "consumer_relative",
    srcs = glob(["*.tf"]),
    absolute_module_source_paths = False,
    module_deps = [
        "//examples/alternatepath",
        "//examples/constants",
        "//examples/transitive",
        "//examples/transitive_relative",
    ],
    visibility = ["//visibility:public"],
)

# This is the same as the above, but with the alternate path to the module.
# This is to test that the module can be found in both locations.
terraform_module(
    name = "alternatepath",
    srcs = glob(["*.tf"]),
    absolute_module_source_paths = False,
    module_deps = [
        "//examples/alternatepath",
        "//examples/constants",
        "//examples/transitive",
        "//examples/transitive_relative",
    ],
    module_path = "./path/to/module",
    visibility = ["//visibility:public"],
)

terraform_working_directory(
    name = "consumer_relative_terraform",
    module = ":consumer_relative",
    terraform = "@terraform_0.12.24//:terraform_executable",
)

terraform_working_directory(
    name = "alternatepath_terraform",
    module = ":alternatepath",
    terraform = "@terraform_0.12.24//:terraform_executable",
)

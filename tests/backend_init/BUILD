load("@tf_modules//rules:module.bzl", "terraform_module")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")

terraform_module(
    name = "provider",
    srcs = ["main.tf"],
    visibility = ["//visibility:public"],
    module_deps = [
        "//tests/backend_init/submodule",
    ],
)

terraform_working_directory(
    name = "terraform",
    module = ":provider",
    allow_provider_download = True,
    init_on_build = False,
)

sh_test(
    name = "terraform_test",
    size = "small",
    srcs = ["test.sh"],
    data = [":terraform"],
)


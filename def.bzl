load("@tf_modules//rules:module.bzl", _terraform_module = "terraform_module")
load("@tf_modules//rules:terraform.bzl", _terraform_executable = "terraform_executable")

def terraform_module(
    name,
    module_path = "",
    srcs = [],
    srcs_flatten = [],
    module_deps = [], 
    provider_binaries=[], 
    provider_versions={}, 
    terraform_executable=Label("@terraform_toolchain//:terraform_executable"),
    ):
    _terraform_module(
        name = name,
        module_path = module_path,
        srcs = srcs,
        srcs_flatten = srcs_flatten,
        module_deps = module_deps,
        provider_binaries = provider_binaries,
        provider_versions = provider_versions,
        visibility = ["//visibility:public"],
    )
    module_ref = ":{}".format(name)
    _terraform_executable(
        name = "terraform",
        module = module_ref,
        terraform = terraform_executable,
    )

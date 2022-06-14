load("@tf_modules//tools/rules:module.bzl", _terraform_module = "terraform_module")
load("@tf_modules//tools/rules:terraform.bzl", _terraform_executable = "terraform_executable")

def terraform_module(name, module_deps = [], provider_binaries=[], terraform_executable=Label("@terraform_toolchain//:terraform_executable")):
    _terraform_module(
        name = name,
        srcs = native.glob(["*.tf"]),
        module_deps = module_deps,
        provider_binaries = provider_binaries,
        visibility = ["//visibility:public"],
    )
    module_ref = ":{}".format(name)
    _terraform_executable(
        name = "terraform",
        module = module_ref,
        terraform = terraform_executable,
    )

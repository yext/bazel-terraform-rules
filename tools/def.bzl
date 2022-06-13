load("@tf_modules//tools/rules:module.bzl", _terraform_module = "terraform_module")
load("@tf_modules//tools/rules:terraform.bzl", _terraform_executable = "terraform_executable")

def terraform_module(name, deps = [], terraform_executable=Label("@terraform_toolchain//:terraform_executable"), module_name = ""):
    _terraform_local_module(
        name = name,
        deps = deps,
        visibility = ["//visibility:public"],
        terraform_executable = terraform_executable,
        module_name = module_name,
    )

def _terraform_local_module(name, deps, visibility, terraform_executable=Label("@terraform_toolchain//:terraform_executable"), module_name = ""):
    _terraform_module(
        name = name,
        srcs = native.glob(["*.tf"]),
        deps = deps,
        module_name = module_name,
        visibility = visibility,
    )
    module_ref = ":{}".format(name)
    _terraform_executable(
        name = "terraform",
        module = module_ref,
        terraform = terraform_executable,
    )

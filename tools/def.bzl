load("@tf_modules//tools/rules:lint.bzl", "terraform_lint_test")
load("@tf_modules//tools/rules:publisher.bzl", _terraform_module_package = "terraform_module_package")
load("@tf_modules//tools/rules:module.bzl", _terraform_module = "terraform_module")
load("@tf_modules//tools/rules:terraform.bzl", _terraform_executable = "terraform_executable")

def terraform_module(name, deps = [], terraform_executable=Label("@terraform_toolchain//:terraform_executable")):
    _terraform_local_module(
        name = name,
        deps = deps,
        visibility = ["//visibility:public"],
        terraform_executable = terraform_executable,
    )
    terraform_module_package(
        name = "publish",
        module = ":{}".format(name),
    )

def _terraform_local_module(name, deps, visibility, terraform_executable=Label("@terraform_toolchain//:terraform_executable")):
    _terraform_module(
        name = name,
        srcs = native.glob(["*.tf"]),
        deps = deps,
        visibility = visibility,
    )
    module_ref = ":{}".format(name)
    _terraform_executable(
        name = "terraform",
        module = module_ref,
        terraform = terraform_executable,
    )
    terraform_lint_test(
        name = "lint",
        module = module_ref,
        tags = ["no-sandbox"],
    )

def terraform_example(name, deps = []):
    _terraform_local_module(
        name = name,
        deps = deps,
        visibility = ["//test:__subpackages__"],
    )

terraform_module_package = _terraform_module_package

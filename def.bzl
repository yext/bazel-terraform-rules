load("@tf_modules//rules:module.bzl", _terraform_module = "terraform_module")
load("@tf_modules//rules:terraform.bzl", _terraform_executable = "terraform_executable")
load("@tf_modules//rules:terragrunt.bzl", _terragrunt_executable = "terragrunt_executable")
load("@bazel_skylib//lib:paths.bzl", "paths")

def terraform_module(
    name,
    module_path = "",
    tf_vars = {},
    srcs = [],
    srcs_flatten = [],
    module_deps = [], 
    provider_binaries=[], 
    provider_versions={}, 
    terraform_executable=Label("@terraform_toolchain//:terraform_executable"),
    absolute_module_source_paths = True,
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
        absolute_module_source_paths = absolute_module_source_paths,
    )
    module_ref = ":{}".format(name)
    _terraform_executable(
        name = "{}_terraform".format(name),
        module = module_ref,
        terraform = terraform_executable,
        tf_vars = tf_vars,
    )
    # If your module name shares the name of the package directory, create
    # an alias to Terraform without the module name prefix
    if name == paths.basename(native.package_name()):
        native.alias(name = "terraform",actual = ":{}_terraform".format(name))

def terragrunt_module(
    name,
    module_path = "",
    tf_vars = {},
    srcs = [],
    srcs_flatten = [],
    module_deps = [], 
    provider_binaries=[], 
    provider_versions={}, 
    terraform_executable=Label("@terraform_toolchain//:terraform_executable"),
    terragrunt_executable=Label("@terragrunt_toolchain//:terragrunt_executable"),
    absolute_module_source_paths = True,
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
        absolute_module_source_paths = absolute_module_source_paths,
    )
    module_ref = ":{}".format(name)
    _terragrunt_executable(
        name = "{}_terragrunt".format(name),
        module = module_ref,
        terraform = terraform_executable,
        terragrunt = terragrunt_executable,
        tf_vars = tf_vars,
    )
    # If your module name shares the name of the package directory, create
    # an alias to Terragrunt without the module name prefix
    if name == paths.basename(native.package_name()):
        native.alias(name = "terragrunt",actual = ":{}_terragrunt".format(name))

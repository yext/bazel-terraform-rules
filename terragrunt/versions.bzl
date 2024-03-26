load("@tf_modules//toolchains/terragrunt:toolchain.bzl", "register_terragrunt_toolchain")

def register_terragrunt_version(version, default = False):
    register_terragrunt_toolchain(version,default)

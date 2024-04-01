load("@tf_modules//toolchains/terraform:toolchain.bzl", "register_terraform_toolchain")

def register_terraform_version(version, default = False):
    register_terraform_toolchain(version,default)

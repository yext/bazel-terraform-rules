load("@tf_modules//toolchains/opentofu:toolchain.bzl", "register_opentofu_toolchain")

def register_opentofu_version(version, default = False):
    register_opentofu_toolchain(version, default)

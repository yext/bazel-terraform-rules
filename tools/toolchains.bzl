load("@tf_modules//tools/toolchains/terraform:toolchain.bzl", "register_terraform_toolchain")

def terraform_register_toolchains(terraform_versions = ["0.12.24"]):
    register_terraform_toolchain(versions = terraform_versions)

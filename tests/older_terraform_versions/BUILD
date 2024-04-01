load("@tf_modules//rules:module.bzl", "terraform_module")
load("@tf_modules//tests/older_terraform_versions:tests.bzl", "test_terraform_version")

terraform_module(
    name = "provider",
    srcs = ["main.tf"],
    visibility = ["//visibility:public"],
)

test_terraform_version(name="terraform", terraform="@terraform_default//:terraform_executable")
test_terraform_version(name="terraform_0_12", terraform="@terraform_0.12.24//:terraform_executable")
test_terraform_version(name="terraform_0_13", terraform="@terraform_0.13.7//:terraform_executable")
test_terraform_version(name="terraform_0_14", terraform="@terraform_0.14.11//:terraform_executable")
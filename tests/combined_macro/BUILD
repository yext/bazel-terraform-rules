load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "provider",
    srcs = glob(["*.tf"]),
    provider_binaries = ["//tests/module_with_providers/example_provider:example_provider_bin"],
    provider_versions = {
        "//tests/module_with_providers/example_provider:example_provider_bin": "terraform.example.com/examplecorp/example/1.0.0",
    },
)

sh_test(
    name = "terraform_test",
    size = "small",
    srcs = ["test.sh"],
    args = ["./tests/combined_macro/provider_terraform"],
    data = [":provider_terraform"],
)

sh_test(
    name = "opentofu_test",
    size = "small",
    srcs = ["test.sh"],
    args = ["./tests/combined_macro/provider_opentofu"],
    data = [":provider_opentofu"],
)

load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "provider",
    srcs = glob(["*.tf"]),
    provider_binaries = ["//examples/provider/example_provider:terraform-provider-example"],
    provider_versions = {
        "//examples/provider/example_provider:terraform-provider-example": "terraform.example.com/examplecorp/example/1.0.0",
    },
)

load("@tf_modules//rules:provider.bzl", "terraform_provider")

terraform_provider(
    name = "provider_hashicorp_local",
    binary = "@com_hashicorp_releases_hashicorp_local//:provider",
    hostname = "registry.terraform.io",
    namespace = "hashicorp",
    type = "local",
    version = "2.4.1",
    visibility = ["//visibility:public"],
)
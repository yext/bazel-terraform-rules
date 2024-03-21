load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")
load("@tf_modules//rules:module.bzl", "terraform_module")
load("@tf_modules//rules:provider.bzl", "terraform_provider")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")

terraform_module(
    name = "provider",
    srcs = ["main.tf"],
    visibility = ["//visibility:public"],
)

terraform_working_directory(
    name = "provider_terraform",
    module = ":provider",
    providers = [
        ":provider_examplecorp_example",
        ":provider_hashicorp_local",
    ],
)

terraform_module(
    name = "provider_legacy",
    srcs = ["main_legacy.tf"],
    visibility = ["//visibility:public"],
)

terraform_working_directory(
    name = "provider_terraform_legacy",
    module = ":provider_legacy",
    providers = [
        ":provider_examplecorp_example",
        ":provider_hashicorp_local",
    ],
    terraform = "@terraform_toolchain-0.12.24//:terraform_executable",
)

terraform_provider(
    name = "provider_examplecorp_example",
    binary = ":terraform-provider-example",
    hostname = "terraform.example.com",
    namespace = "examplecorp",
    type = "example",
    version = "1.0.0",
    visibility = ["//visibility:public"],
)

terraform_provider(
    name = "provider_hashicorp_local",
    binary = "@com_hashicorp_releases_hashicorp_local//:provider",
    hostname = "registry.terraform.io",
    namespace = "hashicorp",
    type = "local",
    version = "2.4.1",
    visibility = ["//visibility:public"],
)

go_binary(
    name = "terraform-provider-example",
    srcs = glob(["*.go"]),
    importpath = "tfmodules/modules/provider",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_hashicorp_terraform_plugin_sdk//helper/schema",
        "@com_github_hashicorp_terraform_plugin_sdk//plugin",
        "@com_github_hashicorp_terraform_plugin_sdk//terraform",
    ],
)

go_library(
    name = "provider_lib",
    srcs = [
        "main.go",
        "provider.go",
        "resource_server.go",
    ],
    importpath = "tfmodules/modules/provider",
    visibility = ["//visibility:private"],
    deps = [
        "@com_github_hashicorp_terraform_plugin_sdk//helper/schema",
        "@com_github_hashicorp_terraform_plugin_sdk//plugin",
        "@com_github_hashicorp_terraform_plugin_sdk//terraform",
    ],
)

load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")
load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "provider",
    srcs_tf = glob(["*.tf"]),
    #terraform_executable = "@terraform_toolchain-0.12.24//:terraform_executable",
    provider_binaries = [":terraform-provider-example"],
    provider_versions = {
        ":terraform-provider-example": "terraform.example.com/examplecorp/example/1.0.0",
    },
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

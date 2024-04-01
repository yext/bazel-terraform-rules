load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")
load("@tf_modules//rules:provider.bzl", "terraform_provider")

terraform_provider(
    name = "provider_examplecorp_example",
    binary = ":example_provider",
    hostname = "terraform.example.com",
    namespace = "examplecorp",
    type = "example",
    version = "1.0.0",
    visibility = ["//visibility:public"],
)

go_library(
    name = "example_provider_lib",
    srcs = [
        "main.go",
        "provider.go",
        "resource_server.go",
    ],
    importpath = "tfmodules/examples/provider/example_provider",
    visibility = ["//visibility:private"],
    deps = [
        "@com_github_hashicorp_terraform_plugin_sdk//helper/schema",
        "@com_github_hashicorp_terraform_plugin_sdk//plugin",
        "@com_github_hashicorp_terraform_plugin_sdk//terraform",
    ],
)

go_binary(
    name = "example_provider",
    embed = [":example_provider_lib"],
    visibility = ["//visibility:public"],
)

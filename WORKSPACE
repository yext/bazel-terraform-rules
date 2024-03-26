workspace(name = "tf_modules")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//:deps.bzl", "bazel_terraform_rules_deps")

bazel_terraform_rules_deps()

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "69de5c704a05ff37862f7e0f5534d4f479418afc21806c887db544a316f3cb6b",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.27.0/rules_go-v0.27.0.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.27.0/rules_go-v0.27.0.tar.gz",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "62ca106be173579c0a167deb23358fdfe71ffa1e4cfdddf5582af26520f1c66f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.16")

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

load("//:repositories.bzl", "go_repositories")

# gazelle:repository_macro repositories.bzl%go_repositories
go_repositories()

gazelle_dependencies()

http_archive(
    name = "com_google_protobuf",
    sha256 = "9748c0d90e54ea09e5e75fb7fac16edce15d2028d4356f32211cfa3c0e956564",
    strip_prefix = "protobuf-3.11.4",
    urls = ["https://github.com/protocolbuffers/protobuf/archive/v3.11.4.zip"],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

load("@tf_modules//terraform:versions.bzl", "register_terraform_version")

register_terraform_version(
    "1.2.9",
    default = True,
)

register_terraform_version("1.2.2")

register_terraform_version("0.12.24")

register_terraform_version("0.12.23")

load("@tf_modules//terragrunt:versions.bzl", "register_terragrunt_version")

register_terragrunt_version(
    "v0.45.2",
    default = True,
)

load("@tf_modules//rules:provider.bzl", "remote_terraform_provider")

remote_terraform_provider(
    name = "provider_hashicorp_local",
    namespace = "hashicorp",
    type = "local",
    version = "2.4.1",

    # Details obtained from:
    # https://registry.terraform.io/v1/providers/hashicorp/local/2.4.1/download/linux/amd64
    # https://registry.terraform.io/v1/providers/hashicorp/local/2.4.1/download/darwin/amd64
    url_by_platform = {
        "linux_amd64": "https://releases.hashicorp.com/terraform-provider-local/2.4.1/terraform-provider-local_2.4.1_linux_amd64.zip",
        "darwin_amd64": "https://releases.hashicorp.com/terraform-provider-local/2.4.1/terraform-provider-local_2.4.1_darwin_amd64.zip",
    },
    sha256_by_platform = {
        "linux_amd64": "244b445bf34ddbd167731cc6c6b95bbed231dc4493f8cc34bd6850cfe1f78528",
        "darwin_amd64": "3c330bdb626123228a0d1b1daa6c741b4d5d484ab1c7ae5d2f48d4c9885cc5e9",
    },
)

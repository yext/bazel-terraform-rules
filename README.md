# Bazel Rules for Terraform

This repository is an extension of the excellent work done by [Dan Vulpe](https://github.com/dvulpe) in experimenting with
creating Bazel rules for Terraform.

# Goals

The goal for this repo is to create a set of Bazel rules for Terraform that make it easier to work with Terraform in a monorepo,
where there are complex directory structures for shared modules, and different modules may use different Terraform versions.

# Usage

## Adding to your repo

See the [release notes](https://github.com/theothertomelliott/bazel-terraform-rules/releases) for instructions for importing this repository into your workspace.

This includes a line to register a specific Terraform version for use, of the form:

```
# Register required Terraform versions
register_terraform_version("1.2.3", default=True)
```

You can specify multiple versions of Terraform by calling `register_terraform_version` multiple times.

Each call to `register_terraform_version` will create a separate repo for that version, the binary for which can be referenced via
the target: `@terraform_{VERSION}//:terraform_executable`.

If you set `default=True` for any call, there will also be a default target for that version: `@terraform_default//:terraform_executable`.
Note that you can only use `default=True` once.

## Declaring a module

To define a Terraform module in Bazel, add a `BUILD` file to the same directory as your `.tf` files with a `terraform_module` rule.

```
load("@tf_modules//rules:module.bzl", "terraform_module")

terraform_module(
    name = "mymodule",
    srcs = glob(["*.tf"]),
    terraform_executable = "@terraform_1.2.0//:terraform_executable",
)
```

The above example will create a module called "mymodule" that can be used as a dependency by any other modules.
The `srcs` attribute accepts any files to include in your module, retaining any directory structure relative to your module's BUILD file.

You may also include files from any other directories and flatten them into your module directory using `srcs_flatten`. This could be used,
for example, to share a file between modules without making copies or symlinks.

When you run `bazel build` against this target, it will assemble the Terraform files and any dependencies into a single package that you could
run Terraform against in isolation.

## Running Terraform

To run Terraform against a module, you need to declare a working directory with the `terraform_working_directory` rule. This can be in the
same package as your module or a totally different package!

```
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")

terraform_working_directory(
    name = "terraform",
    module = ":mymodule",
)
```

When this target is built, it will assemble the module and run `terraform init` on it to generate a `.terraform` 
directory.

You can pass any Terraform commands and parameters to this target.

```
bazel run //path/to/package:terraform -- plan
bazel run //path/to/package:terraform -- apply
```

If your `terraform_module` also has the same name as your package directory, an alias to the Terraform target
will be created with the name `:terraform` for convenience. So the following commands would execute the same
operation:

```
bazel run //path/to/mymodule:mymodule_terraform -- plan
bazel run //path/to/mymodule:terraform -- plan
```

## Module Dependencies

You can specify dependencies on other modules using the `module_deps` parameter of `terraform_module`:

```
terraform_module(
    name = "mymodule",
    srcs = glob(["*.tf"]),
    module_deps = [
        "//examples/module_a",
        "//examples/module_b",
    ],
)
```

This will create dependencies on `module_a` and `module_b`. These must be referenced in your `.tf` files using
the full path from the root of your workspace:

```
module "a" {
  source = "./modules/module_a"
  ...
}

module "b" {
  source = "./modules/module_b"
  ...
}
```

You may also include other modules relative to yours within your `src` files. This allows you to preserve an
existing directory structure, but may result in your modules being less reusable within your workspace.

## Providers

Terraform providers must be defined in your `WORKSPACE` to be provided to your `terraform_working_directory`
so they can load them during the build phase.

You must provide a set of URLs and SHA256 sums by the platforms you want to support. These can be obtained by
navigating the [Terraform Provider Registry Protocol](https://developer.hashicorp.com/terraform/internals/provider-registry-protocol).
An example is provided below for the [hashicorp/local](https://registry.terraform.io/providers/hashicorp/local/latest) provider.

```
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
```

Thes can be referenced in your `terraform_working_directory` by specifying the `provider` target in the repository created:

```
terraform_working_directory(
    name = "terraform",
    module = ":module",
    providers = [
        "@provider_hashicorp_local//:provider",
    ],
)
```

You can also define custom Terraform providers using the `terraform_provider` rule:

```
load("@tf_modules//rules:provider.bzl", "terraform_provider")

terraform_provider(
    name = "example_provider",
    binary = ":provider_bin",
    hostname = "terraform.example.com",
    namespace = "examplecorp",
    type = "example",
    version = "1.0.0",
)

go_binary(
    name = "provider_bin",
    embed = [":provider_lib"],
)

terraform_working_directory(
    name = "terraform",
    module = ":module",
    providers = [
        ":example_provider",
    ],
)
```

This example creates a Go binary for a custom provider, and then defines a `terraform_provider` for it. This is then
used by a `terraform_working_directory`.

The above example would match with the below Terraform code:

```
terraform {
  required_providers {
    example = {
      source  = "terraform.example.com/examplecorp/example"
      version = ">= 1.0"
    }
  }
}
```

For Terraform versions below `0.13`, the `required_providers` stanza is not required.
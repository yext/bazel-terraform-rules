# Bazel Rules for Terraform

This repository is an extension of the excellent work done by [Dan Vulpe](https://github.com/dvulpe) in experimenting with
creating Bazel rules for Terraform.

# Goals

The goal for this repo is to create a set of Bazel rules for Terraform that make it easier to work with Terraform in a monorepo,
where there are complex directory structures for shared modules, and different modules may use different Terraform versions.

# Usage

## Adding to your repo

First, you will need to add this repo as a dependency. Add the below to your `WORKSPACE` file:

```
# Skylib dependency required for Terraform rules
http_archive(
    name = "bazel_skylib",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
    ],
    sha256 = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728",
)
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()

# Add Terraform rules as repository
TF_MODULES_VERSION="0.0.7"
http_archive(
    name = "tf_modules",
    urls = ["https://github.com/theothertomelliott/bazel-terraform-rules/archive/refs/tags/{}.tar.gz".format(TF_MODULES_VERSION)],
    sha256 = "d8ffda4de088613914b7da6e1f9ff79053440dae56fc8add58e93a9692df36f6",
    strip_prefix = "bazel-terraform-rules-{}".format(TF_MODULES_VERSION),
)
load("@tf_modules//toolchains/terraform:toolchain.bzl", "register_terraform_toolchain")

# Register required Terraform versions
register_terraform_toolchain("1.2.3", default=True)
```

You can specify multiple versions of Terraform by calling `register_terraform_toolchain` multiple times.

Each call to `register_terraform_toolchain` will create a separate repo for that version, the binary for which can be referenced via
the target: `@terraform_toolchain-{VERSION}//:terraform_executable`.

If you set `default=True` for any call, there will also be a default target for that version: `@terraform_toolchain//:terraform_executable`.
Note that you can only use `default=True` once.

## Declaring a module

To use a Terraform module in Bazel, add a `BUILD` file to the same directory as the module with a `terraform_module` rule.

```
load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "mymodule",
    srcs = glob(["*.tf"]),
    terraform_executable = "@terraform_toolchain-1.2.0//:terraform_executable",
)
```

The above example will create a module called "mymodule", using Terraform version 1.2.0. The `srcs` attribute accepts any files to include
in your module, retaining any directory structure relative to your module's BUILD file.

You may also include files from any other directories and flatten them into your module directory using `srcs_flatten`. This could be used,
for example, to share a file between modules without making copies or symlinks.

## Running Terraform

Each module defined with `terraform_module` will have a `:terraform` target that you can use to run arbitrary Terraform commands:

```
bazel run //path/to/mymodule:terraform -- plan
bazel run //path/to/mymodule:terraform -- apply
```

## Module Dependencies

You can specify dependencies on other modules using the `module_deps` parameter of `terraform_module`:

```
terraform_module(
    name = "mymodule",
    srcs = glob(["*.tf"]),
    module_deps = [
        "//modules/module_a",
        "//modules/module_b",
    ],
)
```

This will create dependencies on `module_a` and `module_b`. These must be referenced in your `.tf` files using the full path from the root of your workspace:

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

You may also include other modules relative to yours within your `src` files. This allows you to preserve an existing directory structure, but may result
in your modules being less reusable within your workspace.

## Custom Providers

The `terraform_module` rule also allows you to build and use custom Terraform providers in the same repo.

```
terraform_module(
    name = "using_provider",
    srcs = glob(["*.tf"]),
    provider_binaries = [":terraform-provider-example"],
    provider_versions = {
        ":terraform-provider-example": "terraform.example.com/examplecorp/example/1.0.0",
    },
)
```

The above adds a dependency on a provider with a binary available from the `:terraform-provider-example` target.

The `provider_versions` map associates each binary with a full source and version for your provider, matching the `required_providers` stanza
in your Terraform files. The above example would match with the below Terraform code:

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

For Terraform versions below `0.13`, `provider_versions` and the `required_providers` stanza are not required.
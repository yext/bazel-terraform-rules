# Terraform modules - a Bazel approach

This repository is an extension of the excellent work done by [Dan Vulpe](https://github.com/dvulpe) in experimenting with
creating Bazel rules for Terraform.

# Goals

The goal for this repo is to create a set of Bazel rules for Terraform that make it easier to work with Terraform in a monorepo,
where there are complex directory structures for shared modules, and different modules may use different Terraform versions.

# Examples

At present, you can run Terraform against the example modules in the `modules` directory using `bazel run`:

```
bazel run //modules/consumer:terraform -- init
bazelisk run //modules/consumer:terraform -- plan
```
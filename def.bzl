load("@tf_modules//rules:module.bzl", "TerraformModuleInfo", "terraform_module_impl")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory_impl")
load("@tf_modules//rules:terragrunt.bzl", "terragrunt_working_directory_impl")

terraform_working_directory = rule(
   implementation = terraform_working_directory_impl,
   executable = True,
    attrs = {
        "module": attr.label(providers = [TerraformModuleInfo]),
        "terraform": attr.label(
            default = Label("@terraform_toolchain//:terraform_executable"),
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
        "tf_vars": attr.string_dict(),
        "provider_binaries": attr.label_list(allow_files = True),
        "provider_versions": attr.label_keyed_string_dict(allow_files = True),
        '_darwin_constraint': attr.label(default = '@platforms//os:macos'),
        '_linux_constraint': attr.label(default = '@platforms//os:linux'),
    },
)

terragrunt_working_directory = rule(
   implementation = terragrunt_working_directory_impl,
   executable = True,
    attrs = {
        "module": attr.label(providers = [TerraformModuleInfo]),
        "terragrunt": attr.label(
            default = Label("@terragrunt_toolchain//:terragrunt_executable"),
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
        "terraform": attr.label(
            default = Label("@terraform_toolchain//:terraform_executable"),
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
        "tf_vars": attr.string_dict(),
    },
)

terraform_module = rule(
    implementation = terraform_module_impl,
    attrs = {
        "module_path": attr.string(
            default = "",
            doc = "The path to be used in the 'source' attribute of module blocks to refer to this module. If not set, the rule will use the path from the root of the workspace to the module's Bazel build file."
        ),
        "srcs": attr.label_list(
            allow_files = True,
            doc = "Source files that make up this Terraform module."    
        ),
        "srcs_flatten": attr.label_list(
            allow_files = True,
            doc = "Source files outside of this package to be included directly in the root of the module directory. For example, for a module in the package //my/package, that includes //other/directory:file.tf in srcs_flatten, the file would be included as if it were under //my/package:file.tf."    
        ),
        "module_deps": attr.label_list(
            providers = [TerraformModuleInfo],
            doc = "Other Terraform modules upon which this module depends.",
        ),
        "absolute_module_source_paths": attr.bool(
            default = True,
            doc = "If True, the 'source' attribute of module blocks for dependencies will be the full path from the workspace root to the module's Bazel build file (prefixed with ./). If False, the 'source' attribute will be the relative paths of the respective .tf files."
        ),
    },
)
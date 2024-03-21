load("@tf_modules//rules:module.bzl", "TerraformModuleInfo", _terraform_module="terraform_module")
load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")
load("@tf_modules//rules:terragrunt.bzl", "terragrunt_working_directory_impl")
load("@bazel_skylib//lib:paths.bzl", "paths")

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

def terraform_module(
    name,
    module_path = "",
    tf_vars = {},
    srcs = [],
    srcs_flatten = [],
    module_deps = [], 
    provider_binaries=[], 
    provider_versions={}, 
    terraform_executable=Label("@terraform_toolchain//:terraform_executable"),
    absolute_module_source_paths = True,
    **kwargs,
    ):

    msg = """
    The combined terraform_module macro is deprecated and will be modified to only generate a module in a future relase. 
    It is recommended to split your Terraform module into terraform_module (from @tf_modules//rules:module.bzl) and 
    terraform_working_directory (from @tf_modules//rules:terraform.bzl) rules.
    """
    print('{red}{msg}{nc}'.format(red='\033[0;31m', msg=msg, nc='\033[0m'))
    
    if name == "terraform":
        fail("The name 'terraform' is reserved for the Terraform executable. Please use a different name for your module.")
        
    # TODO: add visibility = ["//visibility:public"], to kwargs if it doesn't exist already

    _terraform_module(
        name = name,
        module_path = module_path,
        srcs = srcs,
        srcs_flatten = srcs_flatten,
        module_deps = module_deps,
        absolute_module_source_paths = absolute_module_source_paths,
        **kwargs,
    )

    providers = []

    # TODO: Populate providers with these binaries
    # provider_binaries = provider_binaries,
    # provider_versions = provider_versions,


    module_ref = ":{}".format(name)
    terraform_working_directory(
        name = "{}_terraform".format(name),
        module = module_ref,
        terraform = terraform_executable,
        tf_vars = tf_vars,
        providers = providers,
        init_on_run = True,
    )
    # If your module name shares the name of the package directory, create
    # an alias to Terraform without the module name prefix
    if name == paths.basename(native.package_name()):
        native.alias(name = "terraform",actual = ":{}_terraform".format(name))
load("@tf_modules//rules:module.bzl", "TerraformModuleInfo")
load("@bazel_skylib//lib:paths.bzl", "paths")

def _terragrunt_executable_impl(ctx):
  module = ctx.attr.module[TerraformModuleInfo]
  module_default = ctx.attr.module[DefaultInfo]
  build_base_path = paths.dirname(ctx.build_file_path)
  runfiles = ctx.runfiles(module_default.files.to_list() + [ctx.executable.terragrunt, ctx.executable.terraform])
  # TODO: build env var string from each variable
  env_vars = ""
  for key in ctx.attr.tf_vars:
    env_vars = "{0}\nexport TF_VAR_{1}={2}".format(env_vars,key,ctx.attr.tf_vars[key])
  ctx.actions.write(
    output = ctx.outputs.executable,
    is_executable = True,
    content = """
BASE_DIR=$(pwd)
export PATH=$BASE_DIR/{3}:$PATH
{2}
cd {0}
pwd
ls
$BASE_DIR/{1} $@
""".format(module.working_directory,ctx.executable.terragrunt.path, env_vars, paths.dirname(ctx.executable.terraform.path)),
  )
  
  return DefaultInfo(
    executable = ctx.outputs.executable,
    runfiles = runfiles
  )

terragrunt_executable = rule(
   implementation = _terragrunt_executable_impl,
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
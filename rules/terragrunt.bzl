load("@bazel_skylib//lib:paths.bzl", "paths")
load("@tf_modules//rules:module.bzl", "TerraformModuleInfo")

def terragrunt_working_directory_impl(ctx):
  module = ctx.attr.module[TerraformModuleInfo]
  module_default = ctx.attr.module[DefaultInfo]
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
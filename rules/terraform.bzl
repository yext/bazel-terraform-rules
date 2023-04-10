load("@tf_modules//rules:module.bzl", "TerraformModuleInfo")

def _terraform_executable_impl(ctx):
  module = ctx.attr.module[TerraformModuleInfo]
  module_default = ctx.attr.module[DefaultInfo]
  runfiles = ctx.runfiles(module_default.files.to_list() + [ctx.executable.terraform])
  # TODO: build env var string from each variable
  env_vars = ""
  for key in ctx.attr.tf_vars:
    env_vars = "{0}\nexport TF_VAR_{1}={2}".format(env_vars,key,ctx.attr.tf_vars[key])
  ctx.actions.write(
    output = ctx.outputs.executable,
    is_executable = True,
    content = """
BASE_DIR=$(pwd)
{2}
cd {0}
$BASE_DIR/{1} init -reconfigure
$BASE_DIR/{1} $@
""".format(module.working_directory,ctx.executable.terraform.short_path, env_vars),
  )
  
  return DefaultInfo(
    executable = ctx.outputs.executable,
    runfiles = runfiles
  )

terraform_executable = rule(
   implementation = _terraform_executable_impl,
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
    },
)
load("@tf_modules//tools/rules:module.bzl", "TerraformModuleInfo")

def _terraform_executable_impl(ctx):
  module = ctx.attr.module[TerraformModuleInfo]
  module_default = ctx.attr.module[DefaultInfo]
  runfiles = ctx.runfiles(module_default.files.to_list() + [ctx.executable.terraform])
  ctx.actions.write(
    output = ctx.outputs.executable,
    is_executable = True,
    content = """
BASE_DIR=$(pwd)
cd {0}
$BASE_DIR/{1} init -reconfigure
$BASE_DIR/{1} $@
""".format(module.module_path,ctx.executable.terraform.short_path),
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
    },
)
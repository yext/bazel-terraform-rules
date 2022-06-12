load("@tf_modules//tools/rules:module.bzl", "TerraformModuleInfo")

def _terraform_binary_impl(ctx):
  module = ctx.attr.module[TerraformModuleInfo]
  runfiles = ctx.runfiles(module.srcs + module.deps.to_list() + [ctx.executable.terraform])
  
  ctx.actions.write(
    output = ctx.outputs.executable,
    is_executable = True,
    content = "./" + ctx.executable.terraform.short_path + " -chdir=" + module.module_path + " $@"
  )
  
  return DefaultInfo(
    executable = ctx.outputs.executable,
    runfiles = runfiles)

terraform_binary = rule(
   implementation = _terraform_binary_impl,
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
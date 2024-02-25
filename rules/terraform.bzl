load("@tf_modules//rules:module.bzl", "TerraformModuleInfo")

def terraform_working_directory_impl(ctx):
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
pwd
$BASE_DIR/{1} init -reconfigure
$BASE_DIR/{1} $@
""".format(module.working_directory,ctx.executable.terraform.short_path, env_vars),
  )
  all_outputs = []
  final_runfiles = runfiles

  # Set the os name for the plugins dir 
  os = ""
  if ctx.target_platform_has_constraint(ctx.attr._darwin_constraint[platform_common.ConstraintValueInfo]):
      os = "darwin"
  if ctx.target_platform_has_constraint(ctx.attr._linux_constraint[platform_common.ConstraintValueInfo]):
      os = "linux"

  for provider in ctx.attr.provider_binaries:
      for f in provider.files.to_list():
          out = ctx.actions.declare_file("terraform.d/plugins/{}_amd64/".format(os) + f.basename)
          all_outputs.append(out)
          ctx.actions.run_shell(
              outputs=[out],
              inputs=depset([f]),
              arguments=[f.path, out.path],
              command="cp $1 $2")

  for provider in ctx.attr.provider_binaries:
      if not provider in ctx.attr.provider_versions.keys():
          continue
      provider_version = ctx.attr.provider_versions[provider]
      for f in provider.files.to_list():
          out = ctx.actions.declare_file("terraform.d/plugins/{1}/{0}_amd64/".format(os,provider_version) + f.basename)
          all_outputs.append(out)
          ctx.actions.run_shell(
              outputs=[out],
              inputs=depset([f]),
              arguments=[f.path, out.path],
              command="cp $1 $2")

  final_runfiles = final_runfiles.merge(ctx.runfiles(all_outputs))

  return DefaultInfo(
    executable = ctx.outputs.executable,
    files = depset(all_outputs),
    runfiles = final_runfiles
  )

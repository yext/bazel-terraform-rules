load("@tf_modules//rules:module.bzl", "TerraformModuleInfo")
load("@tf_modules//rules:provider.bzl", "TerraformProviderInfo")
load("@bazel_skylib//lib:paths.bzl", "paths")

def terraform_working_directory_impl(ctx):
  module = ctx.attr.module[TerraformModuleInfo]
  module_default = ctx.attr.module[DefaultInfo]
  all_outputs = []
  working_dir_prefix = ctx.label.name + "_working/"
  working_dir = working_dir_prefix + module.working_directory + "/"
  build_base_path = paths.dirname(ctx.build_file_path)

  for f in module_default.files.to_list():
    out_path = working_dir_prefix + f.short_path
    out = ctx.actions.declare_file(out_path)
    all_outputs.append(out)
    ctx.actions.run_shell(
        outputs=[out],
        inputs=depset([f]),
        arguments=[f.path, out.path],
        command="cp $1 $2")
  
  # Construct environment variables for each terraform variable
  env_vars = ""
  for key in ctx.attr.tf_vars:
    env_vars = "{0}\nexport TF_VAR_{1}={2}".format(env_vars,key,ctx.attr.tf_vars[key])

  dot_tf_prep = ""
  if not ctx.attr.init_on_run:
    dot_tf_prep = "tar -xvzf .terraform.tar.gz > /dev/null"

  # Create the script that runs Terraform
  ctx.actions.write(
    output = ctx.outputs.executable,
    is_executable = True,
    content = """
BASE_DIR=$(pwd)
{2}
cd {0}
{3}
$BASE_DIR/{1} $@
""".format(build_base_path + "/" + working_dir, ctx.executable.terraform.path, env_vars, dot_tf_prep, working_dir_prefix),
  )

  installation = ""
  if not ctx.attr.init_on_run:
    installation = """
provider_installation {
  filesystem_mirror {
    path    = "./terraform.d/plugins"
    include = ["*/*/*"]
  }
}
"""

  intermediates = []

  # Create the terraformrc file
  initrc = ctx.actions.declare_file(working_dir + "init.tfrc")
  intermediates.append(initrc)
  ctx.actions.write(
    output = initrc,
    content = """
disable_checkpoint = true

{}
    """.format(installation)
  )

  for provider in ctx.attr.providers:
      for f in provider.files.to_list():
          f_out = f.short_path.replace(provider.label.package + "/","",1)
          out = ctx.actions.declare_file(working_dir + "terraform.d/{0}".format(f_out))
          intermediates.append(out)
          ctx.actions.run_shell(
              outputs=[out],
              inputs=depset([f]),
              arguments=[f.path, out.path],
              command="cp $1 $2")

  if not ctx.attr.init_on_run:
    tf_lock = ctx.actions.declare_file(working_dir + ".terraform.lock.hcl")
    dot_terraform_tar = ctx.actions.declare_file(working_dir + ".terraform.tar.gz")
    ctx.actions.run_shell(
      outputs=[tf_lock, dot_terraform_tar],
      inputs=all_outputs + intermediates + [ctx.executable.terraform],
      arguments=[
        dot_terraform_tar.dirname, 
        ctx.executable.terraform.path, 
        dot_terraform_tar.basename, 
        initrc.basename,
        tf_lock.basename],
      command="""
        TF=$(pwd)/$2
        cd $1
        TF_CLI_CONFIG_FILE=$(pwd)/$4 $TF init -backend=false
        if [ $? -ne 0 ]; then
          exit 1
        fi
        TF_CLI_CONFIG_FILE=$(pwd)/$4 $TF validate
        if [ $? -ne 0 ]; then
          exit 1
        fi
        tar hczf $3 .terraform
        if [ $? -ne 0 ]; then
          exit 1
        fi
        touch $5 # ensure the lock file exists (older Terraform versions don't create it)
      """,
    )
    all_outputs.append(tf_lock)
    all_outputs.append(dot_terraform_tar)

  # TODO The legacy cache is needed for Terraform 0.12
  return DefaultInfo(
    executable = ctx.outputs.executable,
    files = depset(all_outputs),
    runfiles = ctx.runfiles(all_outputs + [ctx.executable.terraform])
  )

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
        "providers": attr.label_list(providers = [TerraformProviderInfo]),
        "init_on_run": attr.bool(default = False),
    },
)

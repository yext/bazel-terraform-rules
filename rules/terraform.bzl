load("@tf_modules//rules:module.bzl", "TerraformModuleInfo")
load("@tf_modules//rules:provider.bzl", "TerraformProviderInfo")

def terraform_working_directory_impl(ctx):
  module = ctx.attr.module[TerraformModuleInfo]
  module_default = ctx.attr.module[DefaultInfo]
  runfiles = ctx.runfiles(module_default.files.to_list() + [ctx.executable.terraform])
  
  # Construct environment variables for each terraform variable
  env_vars = ""
  for key in ctx.attr.tf_vars:
    env_vars = "{0}\nexport TF_VAR_{1}={2}".format(env_vars,key,ctx.attr.tf_vars[key])

  # Create the script that runs Terraform
  ctx.actions.write(
    output = ctx.outputs.executable,
    is_executable = True,
    content = """
BASE_DIR=$(pwd)
{2}
cd {0}
tar -xvzf .terraform.tar.gz > /dev/null
$BASE_DIR/{1} $@
""".format(module.working_directory,ctx.executable.terraform.short_path, env_vars),
  )
  files_with_providers = runfiles.files.to_list()

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

  # Create the terraformrc file
  initrc = ctx.actions.declare_file("init.tfrc")
  files_with_providers.append(initrc)
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
          out = ctx.actions.declare_file("terraform.d/{0}".format(f_out))
          files_with_providers.append(out)
          ctx.actions.run_shell(
              outputs=[out],
              inputs=depset([f]),
              arguments=[f.path, out.path],
              command="cp $1 $2")

  buildfiles = depset([])

  if not ctx.attr.init_on_run:
    tf_lock = ctx.actions.declare_file(".terraform.lock.hcl")
    dot_terraform_tar = ctx.actions.declare_file(".terraform.tar.gz")

    ctx.actions.run_shell(
      outputs=[tf_lock, dot_terraform_tar],
      inputs=files_with_providers,
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
        TF_CLI_CONFIG_FILE=$(pwd)/$4 $TF validate
        tar hczf $3 .terraform
        touch $5 # ensure the lock file exists (older Terraform versions don't create it)
      """,
    )
    buildfiles = depset([tf_lock, dot_terraform_tar])
    final_runfiles = runfiles.merge(ctx.runfiles([tf_lock, dot_terraform_tar]))
  else:
    final_runfiles = runfiles

  # TODO The legacy cache is needed for Terraform 0.12
  return DefaultInfo(
    executable = ctx.outputs.executable,
    files = buildfiles,
    runfiles = final_runfiles
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

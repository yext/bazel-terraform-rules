load("@bazel_skylib//lib:paths.bzl", "paths")
load("@tf_modules//rules:module.bzl", "TerraformModuleInfo")
load("@tf_modules//rules:provider.bzl", "TerraformProviderInfo")
load("@tf_modules//toolchains/terraform:toolchain.bzl", "TerraformExecutableInfo")

def terraform_working_directory_impl(ctx):
  module = ctx.attr.module[TerraformModuleInfo]
  terraform_version = ctx.attr.terraform[TerraformExecutableInfo].version
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

  prep_command = "tar -xvzf .terraform.tar.gz > /dev/null"

  # Create the script that runs Terraform
  ctx.actions.write(
    output = ctx.outputs.executable,
    is_executable = True,
    content = """
BASE_PATH=$(pwd)
{2}
cd {0}
{3}
$BASE_PATH/{1} $@
""".format(
    build_base_path + "/" + working_dir, 
    ctx.executable.terraform.short_path, 
    env_vars, 
    prep_command,
  ),
)

  included_providers = []
  for provider in ctx.attr.providers:
      provider_info = provider[TerraformProviderInfo]
      included_providers.append("{}/{}/{}".format(provider_info.hostname, provider_info.namespace, provider_info.type))

  installation = ""
  if ctx.attr.allow_provider_download:
    installation = """
provider_installation {
  filesystem_mirror {
    path    = "./terraform.d/plugins"
    include = %PROVIDERS%
  }
  direct {
    include = ["*/*/*"]
    exclude = %PROVIDERS%
  }
}
""".replace("%PROVIDERS%", json.encode(included_providers))

  else:
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
      provider_info = provider[TerraformProviderInfo]
      for f in provider.files.to_list():
          f_out = provider_info.file_to_subpath[f.path]
          out = ctx.actions.declare_file(working_dir + "terraform.d/{0}".format(f_out))
          intermediates.append(out)

          ctx.actions.run_shell(
              outputs=[out],
              inputs=depset([f]),
              arguments=[f.path, out.path],
              command="cp $1 $2"
          )

  tf_lock = ctx.actions.declare_file(working_dir + ".terraform.lock.hcl")
  dot_terraform = ctx.actions.declare_directory(working_dir + ".terraform")
  dot_terraform_tar = ctx.actions.declare_file(working_dir + ".terraform.tar.gz")
  ctx.actions.run_shell(
    outputs=[tf_lock, dot_terraform],
    inputs=all_outputs + intermediates + [ctx.executable.terraform],
    env = {
      "TF_RELATIVE": ctx.executable.terraform.path,
      "WORKING_DIR": dot_terraform_tar.dirname,
      "TF_CLI_CONFIG_FILE": initrc.basename,
      "TF_LOCK": tf_lock.basename,
    },
    command="""
      TF=$(pwd)/$TF_RELATIVE
      cd $WORKING_DIR

      mkdir -p .terraform
      mkdir -p terraform.d/plugins
      touch $TF_LOCK # ensure the lock file exists (older Terraform versions don't create it)

      $TF init -backend=false
      if [ $? -ne 0 ]; then
        exit 1
      fi
      $TF validate
      if [ $? -ne 0 ]; then
        exit 1
      fi
    """,
  )
  all_outputs.append(tf_lock)

  ctx.actions.run_shell(
    progress_message="Compressing .terraform directory",
    outputs=[dot_terraform_tar],
    inputs=[dot_terraform],
    env = {
      "WORKING_DIR": dot_terraform_tar.dirname,
      "DOT_TERRAFORM_TAR": dot_terraform_tar.basename,
    },
    command="""
      cd $WORKING_DIR
      tar hczf $DOT_TERRAFORM_TAR .terraform
      if [ $? -ne 0 ]; then
        exit 1
      fi
    """,
  )
  all_outputs.append(dot_terraform_tar)

  # The legacy cache is needed for Terraform 0.13 and lower
  if terraform_version < "0.14":
    all_outputs += intermediates

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
            default = Label("@terraform_default//:terraform_executable"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
            providers = [TerraformExecutableInfo],
        ),
        "tf_vars": attr.string_dict(),
        "providers": attr.label_list(providers = [TerraformProviderInfo]),
        "allow_provider_download": attr.bool(default=False),
    },
)

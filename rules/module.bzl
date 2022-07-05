load("@bazel_skylib//lib:paths.bzl", "paths")

TerraformModuleInfo = provider(
    doc = "Contains information about a Terraform module",
    fields = ["module_path"],
)

def _impl(ctx):
    all_outputs = []
    module_path = paths.dirname(ctx.build_file_path)

    # Copy source files relative to the module path.
    for f in ctx.files.srcs:
        out_path = paths.relativize(f.short_path,module_path)
        out = ctx.actions.declare_file(out_path)
        all_outputs += [out]
        ctx.actions.run_shell(
            outputs=[out],
            inputs=depset([f]),
            arguments=[f.path, out.path],
            command="cp $1 $2")

    # Copy "flattened" sourc files to the root of the module path.
    for f in ctx.files.srcs_flatten:
        out = ctx.actions.declare_file(f.basename)
        all_outputs += [out]
        ctx.actions.run_shell(
            outputs=[out],
            inputs=depset([f]),
            arguments=[f.path, out.path],
            command="cp $1 $2")

    # Copy all module dependencies alongside the source files.
    # The path to each dependency will be the full path from the workspace root.
    for dep in ctx.attr.module_deps:
        for item in dep[DefaultInfo].files.to_list():
            
            # Ensure plugins are all in the root of the module hierarchy
            path = item.short_path
            if path.startswith(dep[TerraformModuleInfo].module_path + "/terraform.d"):
                path = path.replace(dep[TerraformModuleInfo].module_path + "/","")

            out = ctx.actions.declare_file(path)
            all_outputs += [out]
            ctx.actions.run_shell(
                outputs=[out],
                inputs=depset([item]),
                arguments=[item.path, out.path],
                command="cp $1 $2")

    # Set the os name for the plugins dir 
    os = ""
    if ctx.target_platform_has_constraint(ctx.attr._darwin_constraint[platform_common.ConstraintValueInfo]):
        os = "darwin"
    if ctx.target_platform_has_constraint(ctx.attr._linux_constraint[platform_common.ConstraintValueInfo]):
        os = "linux"

    for provider in ctx.attr.provider_binaries:
        for f in provider.files.to_list():
            out = ctx.actions.declare_file("terraform.d/plugins/{}_amd64/".format(os) + f.basename)
            all_outputs += [out]
            ctx.actions.run_shell(
                outputs=[out],
                inputs=depset([f]),
                arguments=[f.path, out.path],
                command="cp $1 $2")

    for provider in ctx.attr.provider_binaries:
        if not provider in ctx.attr.provider_versions.keys():
            continue
        providerVersion = ctx.attr.provider_versions[provider]
        for f in provider.files.to_list():
            out = ctx.actions.declare_file("terraform.d/plugins/{1}/{0}_amd64/".format(os,providerVersion) + f.basename)
            all_outputs += [out]
            ctx.actions.run_shell(
                outputs=[out],
                inputs=depset([f]),
                arguments=[f.path, out.path],
                command="cp $1 $2")

    return [
        DefaultInfo(
            files = depset(all_outputs),
        ),
        TerraformModuleInfo(
            module_path = module_path,
        ),
    ]

terraform_module = rule(
    implementation = _impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "srcs_flatten": attr.label_list(allow_files = True),
        "module_deps": attr.label_list(providers = [TerraformModuleInfo]),
        "terraform": attr.label(
            default = Label("@terraform_toolchain//:terraform_executable"),
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
        "provider_binaries": attr.label_list(allow_files = True),
        "provider_versions": attr.label_keyed_string_dict(allow_files = True),
        '_darwin_constraint': attr.label(default = '@platforms//os:macos'),
        '_linux_constraint': attr.label(default = '@platforms//os:linux'),
    },
)
TerraformModuleInfo = provider(
    doc = "Contains information about a Terraform module",
    fields = ["module_path"],
)

def _impl(ctx):
    all_outputs = []

    # Copy source files to the root of the target output.
    for f in ctx.files.srcs:
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
            out = ctx.actions.declare_file(dep[TerraformModuleInfo].module_path + "/" + item.basename)
            all_outputs += [out]
            ctx.actions.run_shell(
                outputs=[out],
                inputs=depset([item]),
                arguments=[item.path, out.path],
                command="cp $1 $2")

    return [
        DefaultInfo(
            files = depset(all_outputs),
        ),
        TerraformModuleInfo(
            module_path = ctx.files.srcs[0].dirname,
        ),
    ]

terraform_module = rule(
    implementation = _impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".tf"]),
        "module_deps": attr.label_list(providers = [TerraformModuleInfo]),
        "terraform": attr.label(
            default = Label("@terraform_toolchain//:terraform_executable"),
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
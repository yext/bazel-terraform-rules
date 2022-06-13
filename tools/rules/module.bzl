TerraformModuleInfo = provider(
    doc = "Contains information about a Terraform module",
    fields = ["module_name", "srcs", "module_path"],
)

def _impl(ctx):
    all_outputs = []
    for f in ctx.files.srcs:
        out = ctx.actions.declare_file(f.basename)
        all_outputs += [out]
        ctx.actions.run_shell(
            outputs=[out],
            inputs=depset([f]),
            arguments=[f.path, out.path],
            command="cp $1 $2")

    for dep in ctx.attr.deps:
        print(dep[TerraformModuleInfo])
        for item in dep[DefaultInfo].files.to_list():
            out = ctx.actions.declare_file(dep[TerraformModuleInfo].module_name + "/" + item.basename)
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
            module_name = ctx.attr.module_name,
            srcs = ctx.files.srcs,
            module_path = ctx.files.srcs[0].dirname,
        ),
    ]

terraform_module = rule(
    implementation = _impl,
    attrs = {
        "module_name": attr.string(
            mandatory = True,
        ),
        "srcs": attr.label_list(allow_files = [".tf"]),
        "deps": attr.label_list(providers = [TerraformModuleInfo]),
        "terraform": attr.label(
            default = Label("@terraform_toolchain//:terraform_executable"),
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
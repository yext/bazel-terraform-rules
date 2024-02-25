load("@bazel_skylib//lib:paths.bzl", "paths")

TerraformModuleInfo = provider(
    doc = "Contains information about a Terraform module",
    fields = ["module_path", "build_base_path", "working_directory", "absolute_module_source_paths"],
)

def terraform_module_impl(ctx):
    all_outputs = []
    build_base_path = paths.dirname(ctx.build_file_path)

    working_directory = build_base_path
    if ctx.attr.absolute_module_source_paths == False:
        working_directory = paths.join(working_directory, build_base_path)

    # Copy source files relative to the module path.
    for f in ctx.files.srcs:

        # Set the path appropriate to how dependencies will be referenced
        out_path = f.short_path
        if ctx.attr.absolute_module_source_paths:
            out_path = paths.relativize(f.short_path,build_base_path)

        out = ctx.actions.declare_file(out_path)
        all_outputs.append(out)
        ctx.actions.run_shell(
            outputs=[out],
            inputs=depset([f]),
            arguments=[f.path, out.path],
            command="cp $1 $2")

    # Copy "flattened" source files to the root of the module path.
    for f in ctx.files.srcs_flatten:
        out = ctx.actions.declare_file(f.basename)
        all_outputs.append(out)
        ctx.actions.run_shell(
            outputs=[out],
            inputs=depset([f]),
            arguments=[f.path, out.path],
            command="cp $1 $2")

    # Copy all module dependencies alongside the source files.
    # The path to each dependency will be the full path from the workspace root.
    for dep in ctx.attr.module_deps:
        for item in dep[DefaultInfo].files.to_list():
            
            # Set the path appropriate to how dependencies will be referenced
            path = item.short_path
            if dep[TerraformModuleInfo].absolute_module_source_paths == False:
                path = path.replace(dep[TerraformModuleInfo].build_base_path,"./",1)
            path = path.replace(dep[TerraformModuleInfo].build_base_path, dep[TerraformModuleInfo].module_path,1)

            # Ensure plugins are all in the root of the module hierarchy        
            if path.startswith(dep[TerraformModuleInfo].module_path + "/terraform.d"):
                path = path.replace(dep[TerraformModuleInfo].module_path + "/", "")

            out = ctx.actions.declare_file(path)
            all_outputs.append(out)
            ctx.actions.run_shell(
                outputs=[out],
                inputs=depset([item]),
                arguments=[item.path, out.path],
                command="cp $1 $2")

    # Set the module source path for this module appropriately
    module_path = ctx.attr.module_path
    if module_path == "":
        module_path = build_base_path

    return [
        DefaultInfo(
            files = depset(all_outputs),
        ),
        TerraformModuleInfo(
            module_path = module_path,
            build_base_path = build_base_path,
            working_directory = working_directory,
            absolute_module_source_paths = ctx.attr.absolute_module_source_paths,
        ),
    ]

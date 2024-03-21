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

terraform_module = rule(
    implementation = terraform_module_impl,
    attrs = {
        "module_path": attr.string(
            default = "",
            doc = "The path to be used in the 'source' attribute of module blocks to refer to this module. If not set, the rule will use the path from the root of the workspace to the module's Bazel build file."
        ),
        "srcs": attr.label_list(
            allow_files = True,
            doc = "Source files that make up this Terraform module."    
        ),
        "srcs_flatten": attr.label_list(
            allow_files = True,
            doc = "Source files outside of this package to be included directly in the root of the module directory. For example, for a module in the package //my/package, that includes //other/directory:file.tf in srcs_flatten, the file would be included as if it were under //my/package:file.tf."    
        ),
        "module_deps": attr.label_list(
            providers = [TerraformModuleInfo],
            doc = "Other Terraform modules upon which this module depends.",
        ),
        "absolute_module_source_paths": attr.bool(
            default = True,
            doc = "If True, the 'source' attribute of module blocks for dependencies will be the full path from the workspace root to the module's Bazel build file (prefixed with ./). If False, the 'source' attribute will be the relative paths of the respective .tf files."
        ),
    },
)
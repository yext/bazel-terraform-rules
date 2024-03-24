TerraformProviderInfo = provider(
    doc = "Contains information about a Terraform provider",
    fields = ["hostname", "namespace", "type", "version", "file_to_subpath"],
)

def terraform_provider_impl(ctx):
    os = ""
    for platform in ctx.attr._os_name:
        if ctx.target_platform_has_constraint(platform[platform_common.ConstraintValueInfo]):
            os = ctx.attr._os_name[platform]
    arch = ""
    for platform in ctx.attr._arch_name:
        if ctx.target_platform_has_constraint(platform[platform_common.ConstraintValueInfo]):
            arch = ctx.attr._arch_name[platform]

    file_to_subpath = {}

    f = ctx.file.binary
    subpath = "plugins/{}_{}/".format(os,arch) + f.basename
    out_legacy = ctx.actions.declare_file(subpath)
    file_to_subpath[out_legacy.path] = subpath
    ctx.actions.run_shell(
        outputs=[out_legacy],
        inputs=depset([f]),
        env = {
            "INPUT_FILE": f.path,
            "OUTPUT_FILE": out_legacy.path,
        },
        command="cp $INPUT_FILE $OUTPUT_FILE"
    )

    target = "{}_{}".format(os, arch)
    subpath = "plugins/{0}/{1}/{2}/terraform-provider-{2}_{3}_{4}.zip".format(
        ctx.attr.hostname,
        ctx.attr.namespace,
        ctx.attr.type,
        ctx.attr.version,
        target)
    out_modern = ctx.actions.declare_file(subpath)
    file_to_subpath[out_modern.path] = subpath

    ctx.actions.run_shell(
        outputs=[out_modern],
        inputs=depset([f]),
        env={
            "INPUT_FILE": f.path,
            "INTERMEDIATE_FILE": f.basename,
            "OUTPUT_FILE": out_modern.path
        },
        command="cp $INPUT_FILE $INTERMEDIATE_FILE && zip $OUTPUT_FILE $INTERMEDIATE_FILE"
    )

    return [
        DefaultInfo(
            files = depset([out_legacy, out_modern]),
        ),
        TerraformProviderInfo(
            hostname = ctx.attr.hostname,
            namespace = ctx.attr.namespace,
            type = ctx.attr.type,
            version = ctx.attr.version,
            file_to_subpath = file_to_subpath,
        ),
    ]

terraform_provider = rule(
   implementation = terraform_provider_impl,
    attrs = {
        "binary": attr.label(mandatory=True, allow_single_file=True),
        "hostname": attr.string(mandatory=True),
        "namespace": attr.string(mandatory=True),
        "type": attr.string(mandatory=True),
        "version": attr.string(mandatory=True),
        "_os_name": attr.label_keyed_string_dict(
            default = {
                '@platforms//os:macos': "darwin",
                '@platforms//os:linux': "linux",
            }
        ), 
        "_arch_name": attr.label_keyed_string_dict(
            default = {
                '@platforms//cpu:x86_64': "amd64",
                '@platforms//cpu:arm64': "arm64",
            }
        )
    },
)

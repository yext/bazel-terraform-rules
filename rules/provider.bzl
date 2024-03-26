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

    executable_name = "terraform-provider-{0}".format(ctx.attr.type)

    f = ctx.file.binary
    subpath = "plugins/{0}_{1}/{2}".format(os,arch, executable_name)
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
            "INTERMEDIATE_FILE": executable_name,
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

def _impl(ctx):
    os = ctx.os.name
    arch = ctx.os.arch

    if os.rfind("mac") != -1:
        os = "darwin"
        if arch == "x86_64":
            arch = "amd64"

    platform = "{}_{}".format(os, arch)

    ctx.download_and_extract(
        url = ctx.attr.url_by_platform[platform], 
        sha256=ctx.attr.sha256_by_platform[platform],
    )
    
    files = ctx.path(".").readdir()
    if len(files) != 1:
        fail("Expected exactly one file in {}, got {}", ctx.attr.url_by_platform[platform], len(files))

    provider_file = files[0].basename

    ctx.file(
        "BUILD",
        content = """
load("@tf_modules//rules:provider.bzl", "terraform_provider")

terraform_provider(
    name = "provider",
    binary = ":{0}",
    hostname = "{1}",
    namespace = "{2}",
    type = "{3}",
    version = "{4}",
    visibility = ["//visibility:public"],
)

exports_files(["{0}"])
""".format(
    provider_file, 
    ctx.attr.hostname,
    ctx.attr.namespace,
    ctx.attr.type,
    ctx.attr.version,
    )
)

remote_terraform_provider = repository_rule(
    implementation=_impl,
    attrs={
        "hostname": attr.string(default="registry.terraform.io"),
        "namespace": attr.string(mandatory=True),
        "type": attr.string(mandatory=True),
        "version": attr.string(mandatory=True),

        "url_by_platform": attr.string_dict(mandatory=True),
        "sha256_by_platform": attr.string_dict(mandatory=True)
    }
)
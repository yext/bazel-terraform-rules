def _impl(ctx):
    os = ctx.os.name
    arch = ctx.os.arch

    if os.rfind("mac") != -1:
        os = "darwin"
        if arch == "x86_64":
            arch = "amd64"

    platform = "{}_{}".format(ctx.os.name, ctx.os.arch)

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

terraform_provider = repository_rule(
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
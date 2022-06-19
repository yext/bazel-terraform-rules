def get_dependencies(version, terraform_checksums):
    darwin_checksum = terraform_checksums["darwin_amd64"]
    linux_checksum = terraform_checksums["linux_amd64"]
    return {
        "darwin_amd64": {
            "os": "darwin",
            "arch": "amd64",
            "sha": darwin_checksum,
            "exec_compatible_with": [
                "@platforms//os:osx",
                "@platforms//cpu:x86_64",
            ],
            "target_compatible_with": [
                "@platforms//os:osx",
                "@platforms//cpu:x86_64",
            ],
        },
        "linux_amd64": {
            "os": "linux",
            "arch": "amd64",
            "sha": linux_checksum,
            "exec_compatible_with": [
                "@platforms//os:linux",
                "@platforms//cpu:x86_64",
            ],
            "target_compatible_with": [
                "@platforms//os:linux",
                "@platforms//cpu:x86_64",
            ],
        },
    }

def declare_terraform_toolchains(version, dependencies):
    for key, info in dependencies.items():
        url = _format_url(version, info["os"], info["arch"])
        name = "terraform_{}".format(key)
        toolchain_name = "{}_toolchain".format(name)

        native.toolchain(
            name = toolchain_name,
            exec_compatible_with = info["exec_compatible_with"],
            target_compatible_with = info["target_compatible_with"],
            toolchain = name,
            toolchain_type = "@tf_modules//tools/toolchains/terraform:toolchain_type",
        )

def _detect_platform_arch(ctx):
    if ctx.os.name == "linux":
        platform, arch = "linux", "amd64"
    elif ctx.os.name == "mac os x":
        platform, arch = "darwin", "amd64"
    else:
        fail("Unsupported operating system: " + ctx.os.name)

    return platform, arch

def _terraform_build_file(ctx, platform, version, terraform_checksums):
    ctx.template(
        "BUILD",
        Label("@tf_modules//tools/toolchains/terraform:BUILD.toolchain"),
        executable = False,
        substitutions = {
            "{name}": "terraform_executable",
            "{version}": version,
            "{dependencies}": str(get_dependencies(version, terraform_checksums)),
        },
    )

def _format_url(version, os, arch):
    url_template = "https://releases.hashicorp.com/terraform/{version}/terraform_{version}_{os}_{arch}.zip"
    return url_template.format(version = version, os = os, arch = arch)

def _impl(ctx):
    platform, arch = _detect_platform_arch(ctx)
    version = ctx.attr.version
    _terraform_build_file(ctx, platform, version, ctx.attr.checksums)

    host = "{}_{}".format(platform, arch)
    info = get_dependencies(version, ctx.attr.checksums)[host]

    ctx.download_and_extract(
        url = _format_url(version, info["os"], info["arch"]),
        sha256 = info["sha"],
        type = "zip",
        output = "terraform",
    )

_terraform_register_toolchains = repository_rule(
    implementation = _impl,
    attrs = {
        "version": attr.string(),
        "checksums": attr.string_dict(allow_empty=False),
    },
)

def register_terraform_toolchain(version, checksums, default = False):
    if default:
        _terraform_register_toolchains(
            name = "terraform_toolchain",
            version = version,
            checksums = checksums,
        )
    _terraform_register_toolchains(
        name = "terraform_toolchain-" + version,
        version = version,
        checksums = checksums,
    )

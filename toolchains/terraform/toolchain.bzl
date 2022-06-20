load("@tf_modules//toolchains/terraform:versions.bzl", "VERSIONS")

def get_dependencies(version):
    out = {}
    for platform in VERSIONS[version]:
        if platform in compatibility.keys():
            out[platform] = {
                "platform": platform,
                "sha": VERSIONS[version][platform]["sha"],
                "exec_compatible_with": compatibility[platform],
                "target_compatible_with": compatibility[platform],
            }
    return out

def declare_terraform_toolchains(version, dependencies):
    for key, info in dependencies.items():
        name = "terraform_{}".format(key)
        toolchain_name = "{}_toolchain".format(name)

        native.toolchain(
            name = toolchain_name,
            exec_compatible_with = info["exec_compatible_with"],
            target_compatible_with = info["target_compatible_with"],
            toolchain = name,
            toolchain_type = "@tf_modules//toolchains/terraform:toolchain_type",
        )

def _detect_platform_arch(ctx):
    if ctx.os.name == "linux":
        platform, arch = "linux", "amd64"
    elif ctx.os.name == "mac os x":
        platform, arch = "darwin", "amd64"
    else:
        fail("Unsupported operating system: " + ctx.os.name)

    return platform, arch

def _terraform_build_file(ctx, version):
    ctx.template(
        "BUILD",
        Label("@tf_modules//toolchains/terraform:BUILD.toolchain"),
        executable = False,
        substitutions = {
            "{name}": "terraform_executable",
            "{version}": version,
            "{dependencies}": str(get_dependencies(version)),
        },
    )

# Mapping compatibility of Terraform versions to Bazel platforms
# Based on list at: https://releases.hashicorp.com/terraform/1.2.3/
compatibility = {
    "darwin_amd64": [
        "@platforms//os:osx",
        "@platforms//cpu:x86_64",
    ],
    "darwin_arm64": [
        "@platforms//os:osx",
        "@platforms//cpu:aarch64",
    ],
    "linux_amd64": [
        "@platforms//os:osx",
        "@platforms//cpu:x86_64",
    ],
}

def _get_url(version, platform):
    return VERSIONS[version][platform]["url"]

def _impl(ctx):
    platform, arch = _detect_platform_arch(ctx)
    version = ctx.attr.version
    _terraform_build_file(ctx, version)

    host = "{}_{}".format(platform, arch)
    info = get_dependencies(version)[host]

    ctx.download_and_extract(
        url = _get_url(version, info["platform"]),
        sha256 = info["sha"],
        type = "zip",
        output = "terraform",
    )

_terraform_register_toolchains = repository_rule(
    implementation = _impl,
    attrs = {
        "version": attr.string(),
    },
)

def register_terraform_toolchain(version, default = False):
    if default:
        _terraform_register_toolchains(
            name = "terraform_toolchain",
            version = version,
        )
    _terraform_register_toolchains(
        name = "terraform_toolchain-" + version,
        version = version,
    )

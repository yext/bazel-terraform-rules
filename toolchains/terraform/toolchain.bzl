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
        Label("@tf_modules//toolchains/terraform:BUILD.terraform"),
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
    # Register repo for new naming convention (since these aren't technically toolchains)
    if default:
        _terraform_register_toolchains(
            name = "terraform_default",
            version = version,
        )
    _terraform_register_toolchains(
        name = "terraform_" + version,
        version = version,
    )

    if default:
        _terraform_register_toolchains(
            name = "terraform_toolchain",
            version = version,
        )
    _terraform_register_toolchains(
        name = "terraform_toolchain-" + version,
        version = version,
    )

TerraformExecutableInfo = provider(
    doc = "Contains information about a version of Terraform's executable.",
    fields = ["version"],
)

def _terraform_executable_impl(ctx):
    # TODO: Add info for the version

    f = ctx.file.binary
    out_executable = ctx.actions.declare_file("terraform_executable")
    ctx.actions.run_shell(
        outputs=[out_executable],
        inputs=depset([f]),
        env = {
            "INPUT_FILE": f.path,
            "OUTPUT_FILE": out_executable.path,
        },
        command="cp $INPUT_FILE $OUTPUT_FILE"
    )

    return [
        DefaultInfo(
            executable = out_executable,
        ),
        TerraformExecutableInfo(
            version = ctx.attr.version,
        ),
    ]

terraform_executable = rule(
    implementation = _terraform_executable_impl,
    executable = True,
    attrs = {
        "binary": attr.label(
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "version": attr.string(),
    },
)
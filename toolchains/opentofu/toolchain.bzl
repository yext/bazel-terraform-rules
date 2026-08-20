load("@tf_modules//toolchains/opentofu:versions.bzl", "VERSIONS")
load("@tf_modules//toolchains/terraform:toolchain.bzl", "IaCExecutableInfo")

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
    elif ctx.os.name == "mac os x" and ctx.os.arch == "amd64":
        platform, arch = "darwin", "amd64"
    elif ctx.os.name == "mac os x" and ctx.os.arch == "aarch64":
        platform, arch = "darwin", "arm64"
    else:
        fail("Unsupported operating system: " + ctx.os.name)

    return platform, arch

def _opentofu_build_file(ctx, version):
    ctx.template(
        "BUILD",
        Label("@tf_modules//toolchains/opentofu:BUILD.opentofu"),
        executable = False,
        substitutions = {
            "{name}": "opentofu_executable",
            "{version}": version,
        },
    )

# Mapping compatibility of OpenTofu versions to Bazel platforms
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
    _opentofu_build_file(ctx, version)

    host = "{}_{}".format(platform, arch)
    info = get_dependencies(version)[host]

    ctx.download_and_extract(
        url = _get_url(version, info["platform"]),
        sha256 = info["sha"],
        type = "zip",
        output = "opentofu",
    )

_opentofu_register_toolchains = repository_rule(
    implementation = _impl,
    attrs = {
        "version": attr.string(),
    },
)

def register_opentofu_toolchain(version, default = False):
    if default:
        _opentofu_register_toolchains(
            name = "opentofu_default",
            version = version,
        )
    _opentofu_register_toolchains(
        name = "opentofu_" + version,
        version = version,
    )

    if default:
        _opentofu_register_toolchains(
            name = "opentofu_toolchain",
            version = version,
        )
    _opentofu_register_toolchains(
        name = "opentofu_toolchain-" + version,
        version = version,
    )

def _opentofu_executable_impl(ctx):
    f = ctx.file.binary
    out_executable = ctx.actions.declare_file("opentofu_executable")
    ctx.actions.run_shell(
        outputs = [out_executable],
        inputs = depset([f]),
        env = {
            "INPUT_FILE": f.path,
            "OUTPUT_FILE": out_executable.path,
        },
        command = "cp $INPUT_FILE $OUTPUT_FILE",
    )

    return [
        DefaultInfo(
            executable = out_executable,
        ),
        IaCExecutableInfo(
            distribution = "opentofu",
            version = ctx.attr.version,
        ),
    ]

opentofu_executable = rule(
    implementation = _opentofu_executable_impl,
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

workspace(name = "tf_modules")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "69de5c704a05ff37862f7e0f5534d4f479418afc21806c887db544a316f3cb6b",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.27.0/rules_go-v0.27.0.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.27.0/rules_go-v0.27.0.tar.gz",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "62ca106be173579c0a167deb23358fdfe71ffa1e4cfdddf5582af26520f1c66f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

go_rules_dependencies()

go_register_toolchains(version = "1.16")

gazelle_dependencies()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

go_repository(
    name = "com_github_bazelbuild_rules_go",
    importpath = "github.com/bazelbuild/rules_go",
    sum = "h1:WQ4iSdQ423T9prTfDgXp0S6f/ig9H0N/bin/SvDZFJg=",
    version = "v0.24.7",
)

go_repository(
    name = "com_github_agext_levenshtein",
    importpath = "github.com/agext/levenshtein",
    sum = "h1:YB2fHEn0UJagG8T1rrWknE3ZQzWM06O8AMAatNn7lmo=",
    version = "v1.2.3",
)

go_repository(
    name = "com_github_agl_ed25519",
    importpath = "github.com/agl/ed25519",
    sum = "h1:w1UutsfOrms1J05zt7ISrnJIXKzwaspym5BTKGx93EI=",
    version = "v0.0.0-20170116200512-5312a6153412",
)

go_repository(
    name = "com_github_alcortesm_tgz",
    importpath = "github.com/alcortesm/tgz",
    sum = "h1:uSoVVbwJiQipAclBbw+8quDsfcvFjOpI5iCf4p/cqCs=",
    version = "v0.0.0-20161220082320-9c5fe88206d7",
)

go_repository(
    name = "com_github_andybalholm_crlf",
    importpath = "github.com/andybalholm/crlf",
    sum = "h1:NNJE6p4LchkmNfNskDUaSbrwxZzr7t2/lj2aS+q4oF0=",
    version = "v0.0.0-20171020200849-670099aa064f",
)

go_repository(
    name = "com_github_anmitsu_go_shlex",
    importpath = "github.com/anmitsu/go-shlex",
    sum = "h1:kFOfPq6dUM1hTo4JG6LR5AXSUEsOjtdm0kw0FtQtMJA=",
    version = "v0.0.0-20161002113705-648efa622239",
)

go_repository(
    name = "com_github_apparentlymart_go_cidr",
    importpath = "github.com/apparentlymart/go-cidr",
    sum = "h1:2mAhrMoF+nhXqxTzSZMUzDHkLjmIHC+Zzn4tdgBZjnU=",
    version = "v1.1.0",
)

go_repository(
    name = "com_github_apparentlymart_go_dump",
    importpath = "github.com/apparentlymart/go-dump",
    sum = "h1:MzVXffFUye+ZcSR6opIgz9Co7WcDx6ZcY+RjfFHoA0I=",
    version = "v0.0.0-20190214190832-042adf3cf4a0",
)

go_repository(
    name = "com_github_apparentlymart_go_textseg",
    importpath = "github.com/apparentlymart/go-textseg",
    sum = "h1:rRmlIsPEEhUTIKQb7T++Nz/A5Q6C9IuX2wFoYVvnCs0=",
    version = "v1.0.0",
)

go_repository(
    name = "com_github_apparentlymart_go_textseg_v12",
    importpath = "github.com/apparentlymart/go-textseg/v12",
    sum = "h1:bNEQyAGak9tojivJNkoqWErVCQbjdL7GzRt3F8NvfJ0=",
    version = "v12.0.0",
)

go_repository(
    name = "com_github_apparentlymart_go_textseg_v13",
    importpath = "github.com/apparentlymart/go-textseg/v13",
    sum = "h1:Y+KvPE1NYz0xl601PVImeQfFyEy6iT90AvPUL1NNfNw=",
    version = "v13.0.0",
)

go_repository(
    name = "com_github_armon_go_radix",
    importpath = "github.com/armon/go-radix",
    sum = "h1:F4z6KzEeeQIMeLFa97iZU6vupzoecKdU5TX24SNppXI=",
    version = "v1.0.0",
)

go_repository(
    name = "com_github_armon_go_socks5",
    importpath = "github.com/armon/go-socks5",
    sum = "h1:0CwZNZbxp69SHPdPJAN/hZIm0C4OItdklCFmMRWYpio=",
    version = "v0.0.0-20160902184237-e75332964ef5",
)

go_repository(
    name = "com_github_bgentry_go_netrc",
    importpath = "github.com/bgentry/go-netrc",
    sum = "h1:xDfNPAt8lFiC1UJrqV3uuy861HCTo708pDMbjHHdCas=",
    version = "v0.0.0-20140422174119-9fd32a8b3d3d",
)

go_repository(
    name = "com_github_cheggaaa_pb",
    importpath = "github.com/cheggaaa/pb",
    sum = "h1:wIkZHkNfC7R6GI5w7l/PdAdzXzlrbcI3p8OAlnkTsnc=",
    version = "v1.0.27",
)

go_repository(
    name = "com_github_cncf_udpa_go",
    importpath = "github.com/cncf/udpa/go",
    sum = "h1:cqQfy1jclcSy/FwLjemeg3SR1yaINm74aQyupQ0Bl8M=",
    version = "v0.0.0-20201120205902-5459f2c99403",
)

go_repository(
    name = "com_github_emirpasic_gods",
    importpath = "github.com/emirpasic/gods",
    sum = "h1:QAUIPSaCu4G+POclxeqb3F+WPpdKqFGlw36+yOzGlrg=",
    version = "v1.12.0",
)

go_repository(
    name = "com_github_flynn_go_shlex",
    importpath = "github.com/flynn/go-shlex",
    sum = "h1:BHsljHzVlRcyQhjrss6TZTdY2VfCqZPbv5k3iBFa2ZQ=",
    version = "v0.0.0-20150515145356-3f9db97f8568",
)

go_repository(
    name = "com_github_gliderlabs_ssh",
    importpath = "github.com/gliderlabs/ssh",
    sum = "h1:6zsha5zo/TWhRhwqCD3+EarCAgZ2yN28ipRnGPnwkI0=",
    version = "v0.2.2",
)

go_repository(
    name = "com_github_go_git_gcfg",
    importpath = "github.com/go-git/gcfg",
    sum = "h1:Q5ViNfGF8zFgyJWPqYwA7qGFoMTEiBmdlkcfRmpIMa4=",
    version = "v1.5.0",
)

go_repository(
    name = "com_github_go_git_go_billy_v5",
    importpath = "github.com/go-git/go-billy/v5",
    sum = "h1:4pl5BV4o7ZG/lterP4S6WzJ6xr49Ba5ET9ygheTYahk=",
    version = "v5.1.0",
)

go_repository(
    name = "com_github_go_git_go_git_fixtures_v4",
    importpath = "github.com/go-git/go-git-fixtures/v4",
    sum = "h1:PbKy9zOy4aAKrJ5pibIRpVO2BXnK1Tlcg+caKI7Ox5M=",
    version = "v4.0.2-0.20200613231340-f56387b50c12",
)

go_repository(
    name = "com_github_go_git_go_git_v5",
    importpath = "github.com/go-git/go-git/v5",
    sum = "h1:8WKMtJR2j8RntEXR/uvTKagfEt4GYlwQ7mntE4+0GWc=",
    version = "v5.3.0",
)

go_repository(
    name = "com_github_go_gl_glfw",
    importpath = "github.com/go-gl/glfw",
    sum = "h1:QbL/5oDUmRBzO9/Z7Seo6zf912W/a6Sr4Eu0G/3Jho0=",
    version = "v0.0.0-20190409004039-e6da0acd62b1",
)

go_repository(
    name = "com_github_go_test_deep",
    importpath = "github.com/go-test/deep",
    sum = "h1:ZrJSEWsXzPOxaZnFteGEfooLba+ju3FYIbOrS+rQd68=",
    version = "v1.0.3",
)

go_repository(
    name = "com_github_golang_snappy",
    importpath = "github.com/golang/snappy",
    sum = "h1:Qgr9rKW7uDUkrbSmQeiDsGa8SjGyCOGtuasMWwvp2P4=",
    version = "v0.0.1",
)

go_repository(
    name = "com_github_google_martian_v3",
    importpath = "github.com/google/martian/v3",
    sum = "h1:wCKgOCHuUEVfsaQLpPSJb7VdYCdTVZQAuOdYm1yc/60=",
    version = "v3.1.0",
)

go_repository(
    name = "com_github_hashicorp_errwrap",
    importpath = "github.com/hashicorp/errwrap",
    sum = "h1:OxrOeh75EUXMY8TBjag2fzXGZ40LB6IKw45YeGUDY2I=",
    version = "v1.1.0",
)

go_repository(
    name = "com_github_hashicorp_go_checkpoint",
    importpath = "github.com/hashicorp/go-checkpoint",
    sum = "h1:MFYpPZCnQqQTE18jFwSII6eUQrD/oxMFp3mlgcqk5mU=",
    version = "v0.5.0",
)

go_repository(
    name = "com_github_hashicorp_go_cleanhttp",
    importpath = "github.com/hashicorp/go-cleanhttp",
    sum = "h1:035FKYIWjmULyFRBKPs8TBQoi0x6d9G4xc9neXJWAZQ=",
    version = "v0.5.2",
)

go_repository(
    name = "com_github_hashicorp_go_getter",
    importpath = "github.com/hashicorp/go-getter",
    sum = "h1:NASsgP4q6tL94WH6nJxKWj8As2H/2kop/bB1d8JMyRY=",
    version = "v1.6.1",
)

go_repository(
    name = "com_github_hashicorp_go_hclog",
    importpath = "github.com/hashicorp/go-hclog",
    sum = "h1:CG6TE5H9/JXsFWJCfoIVpKFIkFe6ysEuHirp4DxCsHI=",
    version = "v0.9.2",
)

go_repository(
    name = "com_github_hashicorp_go_multierror",
    importpath = "github.com/hashicorp/go-multierror",
    sum = "h1:H5DkEtf6CXdFp0N0Em5UCwQpXMWke8IA0+lD48awMYo=",
    version = "v1.1.1",
)

go_repository(
    name = "com_github_hashicorp_go_plugin",
    importpath = "github.com/hashicorp/go-plugin",
    sum = "h1:4d/wJojzvHV1I4i/rrjVaeuyxWrLzDE1mDCyDy8fXS8=",
    version = "v1.3.0",
)

go_repository(
    name = "com_github_hashicorp_go_safetemp",
    importpath = "github.com/hashicorp/go-safetemp",
    sum = "h1:2HR189eFNrjHQyENnQMMpCiBAsRxzbTMIgBhEyExpmo=",
    version = "v1.0.0",
)

go_repository(
    name = "com_github_hashicorp_go_uuid",
    importpath = "github.com/hashicorp/go-uuid",
    sum = "h1:cfejS+Tpcp13yd5nYHWDI6qVCny6wyX2Mt5SGur2IGE=",
    version = "v1.0.2",
)

go_repository(
    name = "com_github_hashicorp_go_version",
    importpath = "github.com/hashicorp/go-version",
    sum = "h1:McDWVJIU/y+u1BRV06dPaLfLCaT7fUTJLp5r04x7iNw=",
    version = "v1.3.0",
)

go_repository(
    name = "com_github_hashicorp_hcl_v2",
    importpath = "github.com/hashicorp/hcl/v2",
    sum = "h1:PsYxySWpMD4KPaoJLnsHwtK5Qptvj/4Q6s0t4sUxZf4=",
    version = "v2.12.0",
)

go_repository(
    name = "com_github_hashicorp_logutils",
    importpath = "github.com/hashicorp/logutils",
    sum = "h1:dLEQVugN8vlakKOUE3ihGLTZJRB4j+M2cdTm/ORI65Y=",
    version = "v1.0.0",
)

go_repository(
    name = "com_github_hashicorp_terraform_config_inspect",
    importpath = "github.com/hashicorp/terraform-config-inspect",
    sum = "h1:l+bLFvHjqtgNQwWxwrFX9PemGAAO2P1AGZM7zlMNvCs=",
    version = "v0.0.0-20210209133302-4fd17a0faac2",
)

go_repository(
    name = "com_github_hashicorp_terraform_exec",
    importpath = "github.com/hashicorp/terraform-exec",
    sum = "h1:R6L2mNpDGSEqtLrSONN8Xth0xYwNrnEVzDz6LF/oJPk=",
    version = "v0.13.3",
)

go_repository(
    name = "com_github_hashicorp_terraform_json",
    importpath = "github.com/hashicorp/terraform-json",
    sum = "h1:9syPD/Y5t+3uFjG8AiWVPu1bklJD8QB8iTCaJASc8oQ=",
    version = "v0.10.0",
)

go_repository(
    name = "com_github_hashicorp_terraform_plugin_sdk",
    importpath = "github.com/hashicorp/terraform-plugin-sdk",
    sum = "h1:V7DUR3yBWFrVB9z3ddpY7kiYVSsq4NYR67NiTs93NQo=",
    version = "v1.17.2",
)

go_repository(
    name = "com_github_hashicorp_terraform_plugin_test_v2",
    importpath = "github.com/hashicorp/terraform-plugin-test/v2",
    sum = "h1:d3Rzmi5bnRzcAZon91FY4TDCMUYdU8c5vpPpf2Tz+c8=",
    version = "v2.2.1",
)

go_repository(
    name = "com_github_hashicorp_terraform_svchost",
    importpath = "github.com/hashicorp/terraform-svchost",
    sum = "h1:HKLsbzeOsfXmKNpr3GiT18XAblV0BjCbzL8KQAMZGa0=",
    version = "v0.0.0-20200729002733-f050f53b9734",
)

go_repository(
    name = "com_github_hashicorp_yamux",
    importpath = "github.com/hashicorp/yamux",
    sum = "h1:kJCB4vdITiW1eC1vq2e6IsrXKrZit1bv/TDYFGMp4BQ=",
    version = "v0.0.0-20181012175058-2f1d1f20f75d",
)

go_repository(
    name = "com_github_huandu_xstrings",
    importpath = "github.com/huandu/xstrings",
    sum = "h1:L18LIDzqlW6xN2rEkpdV8+oL/IXWJ1APd+vsdYy4Wdw=",
    version = "v1.3.2",
)

go_repository(
    name = "com_github_jbenet_go_context",
    importpath = "github.com/jbenet/go-context",
    sum = "h1:BQSFePA1RWJOlocH6Fxy8MmwDt+yVQYULKfN0RoTN8A=",
    version = "v0.0.0-20150711004518-d14ea06fba99",
)

go_repository(
    name = "com_github_jessevdk_go_flags",
    importpath = "github.com/jessevdk/go-flags",
    sum = "h1:1jKYvbxEjfUl0fmqTCOfonvskHHXMjBySTLW4y9LFvc=",
    version = "v1.5.0",
)

go_repository(
    name = "com_github_jhump_protoreflect",
    importpath = "github.com/jhump/protoreflect",
    sum = "h1:h5jfMVslIg6l29nsMs0D8Wj17RDVdNYti0vDN/PZZoE=",
    version = "v1.6.0",
)

go_repository(
    name = "com_github_jmespath_go_jmespath_internal_testify",
    importpath = "github.com/jmespath/go-jmespath/internal/testify",
    sum = "h1:shLQSRRSCCPj3f2gpwzGwWFoC7ycTf1rcQZHOlsJ6N8=",
    version = "v1.5.1",
)

go_repository(
    name = "com_github_kevinburke_ssh_config",
    importpath = "github.com/kevinburke/ssh_config",
    sum = "h1:DowS9hvgyYSX4TO5NpyC606/Z4SxnNYbT+WX27or6Ck=",
    version = "v0.0.0-20201106050909-4977a11b4351",
)

go_repository(
    name = "com_github_keybase_go_crypto",
    importpath = "github.com/keybase/go-crypto",
    sum = "h1:NARVGAAgEXvoMeNPHhPFt1SBt1VMznA3Gnz9d0qj+co=",
    version = "v0.0.0-20161004153544-93f5b35093ba",
)

go_repository(
    name = "com_github_klauspost_compress",
    importpath = "github.com/klauspost/compress",
    sum = "h1:MiK62aErc3gIiVEtyzKfeOHgW7atJb5g/KNX5m3c2nQ=",
    version = "v1.11.2",
)

go_repository(
    name = "com_github_kylelemons_godebug",
    importpath = "github.com/kylelemons/godebug",
    sum = "h1:RPNrshWIDI6G2gRW9EHilWtl7Z6Sb1BR0xunSBf0SNc=",
    version = "v1.1.0",
)

go_repository(
    name = "com_github_masterminds_goutils",
    importpath = "github.com/Masterminds/goutils",
    sum = "h1:zukEsf/1JZwCMgHiK3GZftabmxiCw4apj3a28RPBiVg=",
    version = "v1.1.0",
)

go_repository(
    name = "com_github_masterminds_semver_v3",
    importpath = "github.com/Masterminds/semver/v3",
    sum = "h1:hLg3sBzpNErnxhQtUy/mmLR2I9foDujNK030IGemrRc=",
    version = "v3.1.1",
)

go_repository(
    name = "com_github_masterminds_sprig",
    importpath = "github.com/Masterminds/sprig",
    sum = "h1:z4yfnGrZ7netVz+0EDJ0Wi+5VZCSYp4Z0m2dk6cEM60=",
    version = "v2.22.0+incompatible",
)

go_repository(
    name = "com_github_masterminds_sprig_v3",
    importpath = "github.com/Masterminds/sprig/v3",
    sum = "h1:P1ekkbuU73Ui/wS0nK1HOM37hh4xdfZo485UPf8rc+Y=",
    version = "v3.2.0",
)

go_repository(
    name = "com_github_mitchellh_cli",
    importpath = "github.com/mitchellh/cli",
    sum = "h1:qj8czE26AU4PbiaPXK5uVmMSM+V5BYsFBiM9HhGRLUA=",
    version = "v1.1.4",
)

go_repository(
    name = "com_github_mitchellh_colorstring",
    importpath = "github.com/mitchellh/colorstring",
    sum = "h1:62I3jR2EmQ4l5rM/4FEfDWcRD+abF5XlKShorW5LRoQ=",
    version = "v0.0.0-20190213212951-d06e56a500db",
)

go_repository(
    name = "com_github_mitchellh_copystructure",
    importpath = "github.com/mitchellh/copystructure",
    sum = "h1:vpKXTN4ewci03Vljg/q9QvCGUDttBOGBIa15WveJJGw=",
    version = "v1.2.0",
)

go_repository(
    name = "com_github_mitchellh_go_wordwrap",
    importpath = "github.com/mitchellh/go-wordwrap",
    sum = "h1:TLuKupo69TCn6TQSyGxwI1EblZZEsQ0vMlAFQflz0v0=",
    version = "v1.0.1",
)

go_repository(
    name = "com_github_mitchellh_reflectwalk",
    importpath = "github.com/mitchellh/reflectwalk",
    sum = "h1:G2LzWKi524PWgd3mLHV8Y5k7s6XUvT0Gef6zxSIeXaQ=",
    version = "v1.0.2",
)

go_repository(
    name = "com_github_niemeyer_pretty",
    importpath = "github.com/niemeyer/pretty",
    sum = "h1:fD57ERR4JtEqsWbfPhv4DMiApHyliiK5xCTNVSPiaAs=",
    version = "v0.0.0-20200227124842-a10e7caefd8e",
)

go_repository(
    name = "com_github_oklog_run",
    importpath = "github.com/oklog/run",
    sum = "h1:Ru7dDtJNOyC66gQ5dQmaCa0qIsAUFY3sFpK1Xk8igrw=",
    version = "v1.0.0",
)

go_repository(
    name = "com_github_pierrec_lz4",
    importpath = "github.com/pierrec/lz4",
    sum = "h1:2xWsjqPFWcplujydGg4WmhC/6fZqK42wMM8aXeqhl0I=",
    version = "v2.0.5+incompatible",
)

go_repository(
    name = "com_github_posener_complete",
    importpath = "github.com/posener/complete",
    sum = "h1:NP0eAhjcjImqslEwo/1hq7gpajME0fTLTezBKDqfXqo=",
    version = "v1.2.3",
)

go_repository(
    name = "com_github_sergi_go_diff",
    importpath = "github.com/sergi/go-diff",
    sum = "h1:XU+rvMAioB0UC3q1MFrIQy4Vo5/4VsRDQQXHsEya6xQ=",
    version = "v1.2.0",
)

go_repository(
    name = "com_github_ulikunitz_xz",
    importpath = "github.com/ulikunitz/xz",
    sum = "h1:ERv8V6GKqVi23rgu5cj9pVfVzJbOqAY2Ntl88O6c2nQ=",
    version = "v0.5.8",
)

go_repository(
    name = "com_github_vmihailenco_msgpack",
    importpath = "github.com/vmihailenco/msgpack",
    sum = "h1:dSLoQfGFAo3F6OoNhwUmLwVgaUXK79GlxNBwueZn0xI=",
    version = "v4.0.4+incompatible",
)

go_repository(
    name = "com_github_vmihailenco_msgpack_v4",
    importpath = "github.com/vmihailenco/msgpack/v4",
    sum = "h1:07s4sz9IReOgdikxLTKNbBdqDMLsjPKXwvCazn8G65U=",
    version = "v4.3.12",
)

go_repository(
    name = "com_github_vmihailenco_tagparser",
    importpath = "github.com/vmihailenco/tagparser",
    sum = "h1:quXMXlA39OCbd2wAdTsGDlK9RkOk6Wuw+x37wVyIuWY=",
    version = "v0.1.1",
)

go_repository(
    name = "com_github_xanzy_ssh_agent",
    importpath = "github.com/xanzy/ssh-agent",
    sum = "h1:wUMzuKtKilRgBAD1sUb8gOwwRr2FGoBVumcjoOACClI=",
    version = "v0.3.0",
)

go_repository(
    name = "com_github_yuin_goldmark",
    importpath = "github.com/yuin/goldmark",
    sum = "h1:/vn0k+RBvwlxEmP5E7SZMqNxPhfMVFEJiykr15/0XKM=",
    version = "v1.4.1",
)

go_repository(
    name = "com_github_zclconf_go_cty",
    importpath = "github.com/zclconf/go-cty",
    sum = "h1:mp9ZXQeIcN8kAwuqorjH+Q+njbJKjLrvB2yIh4q7U+0=",
    version = "v1.10.0",
)

go_repository(
    name = "com_github_zclconf_go_cty_debug",
    importpath = "github.com/zclconf/go-cty-debug",
    sum = "h1:FosyBZYxY34Wul7O/MSKey3txpPYyCqVO5ZyceuQJEI=",
    version = "v0.0.0-20191215020915-b22d67c1ba0b",
)

go_repository(
    name = "com_github_zclconf_go_cty_yaml",
    importpath = "github.com/zclconf/go-cty-yaml",
    sum = "h1:dNyg4QLTrv2IfJpm7Wtxi55ed5gLGOlPrZ6kMd51hY0=",
    version = "v1.0.2",
)

go_repository(
    name = "in_gopkg_yaml_v3",
    importpath = "gopkg.in/yaml.v3",
    sum = "h1:h8qDotaEPuJATrMmW04NCwg7v22aHH28wwpauUhK9Oo=",
    version = "v3.0.0-20210107192922-496545a6307b",
)

go_repository(
    name = "io_rsc_quote_v3",
    importpath = "rsc.io/quote/v3",
    sum = "h1:9JKUTTIUgS6kzR9mK1YuGKv6Nl+DijDNIc0ghT58FaY=",
    version = "v3.1.0",
)

go_repository(
    name = "io_rsc_sampler",
    importpath = "rsc.io/sampler",
    sum = "h1:7uVkIFmeBqHfdjD+gZwtXXI+RODJ2Wc4O7MPEh/QiW4=",
    version = "v1.3.0",
)

go_repository(
    name = "org_golang_google_protobuf",
    importpath = "google.golang.org/protobuf",
    sum = "h1:SnqbnDw1V7RiZcXPx5MEeqPv2s79L9i7BJUlG/+RurQ=",
    version = "v1.27.1",
)

go_repository(
    name = "org_golang_x_term",
    importpath = "golang.org/x/term",
    sum = "h1:9zKuko04nR4gjZ4+DNjHqRlAJqbJETHwiNKDqTfOjfE=",
    version = "v0.0.0-20210615171337-6886f2dfbf5b",
)

load("//:repositories.bzl", "go_repositories")

# gazelle:repository_macro repositories.bzl%go_repositories
go_repositories()

gazelle_dependencies()

http_archive(
    name = "com_google_protobuf",
    sha256 = "9748c0d90e54ea09e5e75fb7fac16edce15d2028d4356f32211cfa3c0e956564",
    strip_prefix = "protobuf-3.11.4",
    urls = ["https://github.com/protocolbuffers/protobuf/archive/v3.11.4.zip"],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

load("@tf_modules//tools/toolchains/terraform:toolchain.bzl", "register_terraform_toolchain")

register_terraform_toolchain("1.2.2",checksums={
    "darwin_amd64": "",
    "linux_amd64": "2934a0e8824925beb956b2edb5fef212a6141c089d29d8568150a43f95b3a626",
    },
    default=True,
)
register_terraform_toolchain("0.12.24", checksums={
    "darwin_amd64": "72482000a5e25c33e88e95d70208304acfd09bf855a7ede110da032089d13b4f",
    "linux_amd64": "602d2529aafdaa0f605c06adb7c72cfb585d8aa19b3f4d8d189b42589e27bf11",
})
register_terraform_toolchain("0.12.23", checksums={
    "darwin_amd64": "ca1a0bc58b4e482d0bdcaee95d002f4901094935fd4b184f57563a5c34fd18d9",
    "linux_amd64": "78fd53c0fffd657ee0ab5decac604b0dea2e6c0d4199a9f27db53f081d831a45",
})

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_pkg",
    sha256 = "352c090cc3d3f9a6b4e676cf42a6047c16824959b438895a76c2989c6d7c246a",
    urls = [
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.2.5/rules_pkg-0.2.5.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.2.5/rules_pkg-0.2.5.tar.gz",
    ],
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

http_archive(
    name = "com_github_bazelbuild_buildtools",
    sha256 = "3c5d48d5dae8222a668e31542ff77b7992b9c4a1d58b0e1b50155dbc88677316",
    strip_prefix = "buildtools-master",
    url = "https://github.com/bazelbuild/buildtools/archive/master.zip",
)

http_archive(
    name = "io_buildbuddy_buildbuddy_toolchain",
    sha256 = "a2a5cccec251211e2221b1587af2ce43c36d32a42f5d881737db3b546a536510",
    strip_prefix = "buildbuddy-toolchain-829c8a574f706de5c96c54ca310f139f4acda7dd",
    urls = ["https://github.com/buildbuddy-io/buildbuddy-toolchain/archive/829c8a574f706de5c96c54ca310f139f4acda7dd.tar.gz"],
)

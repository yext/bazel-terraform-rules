load("@tf_modules//rules:terraform.bzl", "terraform_working_directory")

def test_terraform_version(
    name,
    terraform,
):
    terraform_working_directory(
        name = name,
        module = ":provider",
        providers = [
            "//tests/module_with_providers/example_provider",
        ],
        terraform = terraform,
    )

    native.sh_test(
        name = "{}_test".format(name),
        args = ["./tests/older_terraform_versions/{}".format(name)],
        size = "small",
        srcs = ["test.sh"],
        data = [":{}".format(name)],
    )

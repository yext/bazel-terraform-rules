load("@tf_modules//:def.bzl", "terraform_module")

terraform_module(
    name = "vars",
    srcs = glob(["*.tf"]),
    tf_vars = {
        "test_input": "test_value"
    }
)

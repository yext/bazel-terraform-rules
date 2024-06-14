load("@tf_modules//rules:terraform.bzl", "TerraformWorkingDirInfo")

def _execute_test_impl(ctx):
    output = ctx.actions.declare_file(ctx.label.name + ".sh")
    working_dir = ctx.attr.terraform_working_directory[DefaultInfo]
    working_dir_info = ctx.attr.terraform_working_directory[TerraformWorkingDirInfo]

    ctx.actions.write(
        output = output,
        content = """
#!/bin/bash

MODULE_DIR="./{module_path}"

echo "hello, world" > $MODULE_DIR/content.txt

OUT=$(./{terraform_binary} apply -auto-approve -no-color)
if [ $? -ne 0 ];
then
    echo 'Plan failed';
    exit 1
fi

PASS=1

if [[ $(cat "$MODULE_DIR/foo.bar") != "hello, world" ]]; then
    echo "FAIL: content of generated file was not as expected"
    PASS=0
fi

if [[ $PASS == 0 ]]; then
    echo "$OUT"
    exit 1
fi
        """.format(
            terraform_binary=working_dir.files_to_run.executable.short_path,
            module_path=working_dir_info.working_dir_short_path,
        ),
        is_executable = True,
    )

    return [
        DefaultInfo(
            executable = output,
            runfiles = working_dir.default_runfiles,
        ),
    ]

execute_test = rule(
    implementation = _execute_test_impl,
    executable = True,
    test = True,
    attrs = {
        "terraform_working_directory": attr.label(mandatory=True),
    }
)
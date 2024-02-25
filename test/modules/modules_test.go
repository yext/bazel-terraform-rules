package constants_test

import (
	"fmt"
	"testing"
	"tfmodules/test/utils"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestConstants(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformBinary: utils.TerraformFinder(t),
		TerraformDir:    "../../examples/constants",
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	check_value(t, "test_constant", "test_value", terraformOptions)
}

func TestConsumer(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformBinary: utils.TerraformFinder(t),
		TerraformDir:    "../../examples/consumer",
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	check_value(t, "test_constant", "test_value", terraformOptions)
	check_value(t, "nested_directories_constant", "test_value2", terraformOptions)
	check_value(t, "nested_non_tf_constant_from_src", "test_value3", terraformOptions)
	check_value(t, "nested_non_tf_constant_flattened", "flattened", terraformOptions)
	check_value(t, "alternate_path_constant", "alternate_source_value", terraformOptions)
}

func check_value(t *testing.T, key string, expectedValue string, terraformOptions *terraform.Options) {
	expected := fmt.Sprintf(`"%v"`, expectedValue)
	actual := terraform.Output(t, terraformOptions, key)
	if expected != actual {
		t.Errorf("Expected %v, got %v", expected, actual)
	}
}

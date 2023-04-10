module "nested_directories" {
  source = "../nested/directories"
}

output "nested_directories_constant" {
  value       = module.nested_directories.test_constant2
}

module "nested_non_tf" {
  source = "../nested/non_tf_sources"
}

output "nested_non_tf_constant_from_src" {
  value       = module.nested_non_tf.test_constant_from_src
}

output "nested_non_tf_constant_flattened" {
  value       = module.nested_non_tf.test_constant_flattened
}
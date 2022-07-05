module "constants" {
  source = "./modules/constants"
}

output "test_constant" {
  value       = module.constants.test_constant
}

module "transitive" {
  source = "./modules/transitive"
}

output "nested_directories_constant" {
  value       = module.transitive.nested_directories_constant
}

output "nested_non_tf_constant_from_src" {
  value       = module.transitive.nested_non_tf_constant_from_src
}

output "nested_non_tf_constant_flattened" {
  value       = module.transitive.nested_non_tf_constant_flattened
}

module "alternate_path" {
  source = "./alternate/module/path"
}

output "alternate_path_constant" {
  value       = module.alternate_path.constant_from_alternate_source
}

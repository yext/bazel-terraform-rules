output "test_constant_from_src" {
  value       = file("${path.module}/data/fromsrc.txt")
  description = "a second test constant"
}

output "test_constant_flattened" {
  value       = file("${path.module}/flatten.txt")
  description = "a second test constant"
}

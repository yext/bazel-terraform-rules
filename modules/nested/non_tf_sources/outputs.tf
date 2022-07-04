output "test_constant3" {
  value       = file("${path.module}/data/value3.txt")
  description = "a second test constant"
}

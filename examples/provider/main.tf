terraform {
  required_providers {
    example = {
      source  = "terraform.example.com/examplecorp/example"
      #version = ">= 1.0"
    }
    local = {
      source = "hashicorp/local"
      version = ">= 2.4.1"
    }
  }
}

resource "example_server" "my-server" {
    address = "1.2.3.4"
}

resource "local_file" "foo" {
  content  = "foo!"
  filename = "${path.module}/foo.bar"
}
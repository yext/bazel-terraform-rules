terraform {
  required_providers {
    example = {
      source  = "terraform.example.com/examplecorp/example"
    }
  }
}

resource "example_server" "my-server" {
    address = "1.2.3.4"
}

terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = ">= 2.4.1"
    }
  }
}

module "submodule" {
  source = "./tests/backend_init/submodule"
}

resource "local_file" "foo" {
  content  = module.submodule.file_content
  filename = "${path.module}/foo.bar"
}


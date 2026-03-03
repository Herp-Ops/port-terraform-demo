terraform {
  required_version = ">= 1.5"

  # Using Terraform Cloud for remote state management
  # This enables collaboration, locking, and audit trails
  cloud {
    organization = "acme-corp"
    workspaces {
      name = "acme-port"
    }
  }

  required_providers {
    port = {
      source  = "port-labs/port-labs"
      version = "~> 2.0"
    }
  }
}

provider "port" {
  client_id = var.port_client_id
  secret    = var.port_client_secret
}

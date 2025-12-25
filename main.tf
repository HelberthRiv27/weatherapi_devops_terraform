

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
  
}

terraform {
    backend "azurerm" {
        resource_group_name  = "weatherapi_storage_rg"
        storage_account_name = "weatherapiterraftstorage"
        container_name       = "tfstatefile"
        key                  = "terraform.tfstate"
        }
}

variable "docker_username" {
  type = string
}

variable "docker_password" {
  type = string
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

resource "azurerm_container_group" "example" {
  name                = "weatherapi"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_address_type     = "Public"
  dns_name_label      = "weatherapicontainerhelberth27"
  os_type             = "Linux"

  container {
    name   = "weatherapi"
    image  = "helriper27/weatherapi"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 8080
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = "index.docker.io"
    username = var.docker_username
    password = var.docker_password
  }

}


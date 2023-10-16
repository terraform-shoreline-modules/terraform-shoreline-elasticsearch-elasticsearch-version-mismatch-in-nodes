terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "elasticsearch_version_mismatch_in_nodes" {
  source    = "./modules/elasticsearch_version_mismatch_in_nodes"

  providers = {
    shoreline = shoreline
  }
}
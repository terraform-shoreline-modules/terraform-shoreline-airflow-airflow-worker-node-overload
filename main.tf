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

module "airflow_worker_node_overload" {
  source    = "./modules/airflow_worker_node_overload"

  providers = {
    shoreline = shoreline
  }
}
locals {
  prefix              = "${var.product}-bootstrap-${var.env}"
  resource_group_name = "${local.prefix}-rg"
  key_vault_name      = "${local.prefix}-kv"
  env_long_name       = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}

data "azurerm_client_config" "current" {}

//At present, this will only create the resource group in the staging environment
resource "azurerm_resource_group" "rg" {
  count    = var.env == "stg" ? 1 : 0
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}
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

module "kv" {
  count                   = var.env == "stg" ? 1 : 0
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg[0].name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = false
}
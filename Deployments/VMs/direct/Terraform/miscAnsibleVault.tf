provider "ansiblevault" {
  vault_path  = var.vault_pass_file
  root_folder = "../inventory/group_vars"
}

data "ansiblevault_path" "mysql_root_password" {
  path = "./ansible_vault.yaml"
  key = "mysql_root_password"
}
output "managed_disk_list" {
  value = {for o in azurerm_managed_disk.managed_disk : o.name => {name : o.name, id : o.id}}
  description = "Map of created disks with name and ID."
}
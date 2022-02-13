output "internal_ip_address_vm_1" {
  value = module.one.internal_ip_address_vm
}

output "external_ip_address_vm_1" {
  value = module.one.external_ip_address_vm
}

output "internal_ip_address_vm_2" {
  value = module.two.internal_ip_address_vm
}

output "external_ip_address_vm_2" {
  value = module.two.external_ip_address_vm
}
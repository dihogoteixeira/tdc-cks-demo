//master node outputs
output "master_name" {
    value = module.master.name
}

output "master_instance_id" {
  value = module.master.instance_id
}

output "master_cpu_platform" {
  value = module.master.cpu_platform
}

output "master_external_ip" {
    value = module.master.external_ip
}

output "master_internal_ip" {
    value = module.master.internal_ip
}

output "master_self_link" {
  value = module.master.self_link
}

//worker node outputs
output "worker_name" {
    value = module.worker.name
}

output "worker_instance_id" {
  value = module.worker.instance_id
}

output "worker_cpu_platform" {
  value = module.worker.cpu_platform
}

output "worker_external_ip" {
    value = module.worker.external_ip
}

output "worker_internal_ip" {
    value = module.worker.internal_ip
}

output "worker_self_link" {
  value = module.worker.self_link
}
output "spark_manager_url" {
  value = "http://${module.master.public-ip}:8080" 
}

output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
}
module "master" {
  source                = "./modules/master"
	region                = var.region
	compartment_ocid      = var.compartment_ocid
  subnet_id             = var.useExistingVcn ? var.publicSubnet : module.network.public-id
	availability_domain   = var.availablity_domain_name
  image_ocid            = var.InstanceImageOCID[var.region]
  ssh_public_key        = tls_private_key.public_private_key_pair.public_key_openssh 
  ssh_private_key       = tls_private_key.public_private_key_pair.private_key_pem
  master_instance_shape = var.master_instance_shape
  user_data             = base64encode(file("scripts/boot.sh"))
	spark_master          = data.null_data_source.values.outputs["spark_default"]
	build_mode            = var.build_mode
	hadoop_version        = var.hadoop_version
	use_hive              = var.use_hive
}

module "worker" {
  source                   = "./modules/worker"
  instances                = var.worker_node_count
	region                   = var.region
	compartment_ocid         = var.compartment_ocid
  subnet_id                = var.useExistingVcn ? var.privateSubnet : module.network.private-id
	availability_domain      = var.availablity_domain_name
	image_ocid               = var.InstanceImageOCID[var.region]
  ssh_public_key           = tls_private_key.public_private_key_pair.public_key_openssh 
  ssh_private_key          = tls_private_key.public_private_key_pair.private_key_pem
  worker_instance_shape    = var.worker_instance_shape
	block_volumes_per_worker = var.block_volumes_per_worker
	data_blocksize_in_gbs    = var.data_blocksize_in_gbs
  user_data                = base64encode(file("scripts/boot.sh"))
	spark_master             = data.null_data_source.values.outputs["spark_default"]
	block_volume_count       = var.block_volumes_per_worker
  build_mode               = var.build_mode
  hadoop_version           = var.hadoop_version
  use_hive                 = var.use_hive
}

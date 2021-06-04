## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "master" {
  source                   = "./modules/master"
	region                   = var.region
	compartment_ocid         = var.compartment_ocid
  subnet_id                = var.useExistingVcn ? var.publicSubnet : module.network.public-id
	availability_domain      = var.availablity_domain_name
  image_ocid               = data.oci_core_images.InstanceImageOCID-M.images[0].id
  ssh_public_key           = tls_private_key.public_private_key_pair.public_key_openssh 
  ssh_private_key          = tls_private_key.public_private_key_pair.private_key_pem
  master_instance_shape    = var.master_instance_shape
  master_flex_shape_ocpus  = var.master_flex_shape_ocpus
  master_flex_shape_memory = var.master_flex_shape_memory
  user_data                = base64encode(file("scripts/boot.sh"))
	spark_master             = data.null_data_source.values.outputs["spark_default"]
	build_mode               = var.build_mode
	hadoop_version           = var.hadoop_version
	use_hive                 = var.use_hive
  spark_version            = var.spark_version
  defined_tags             = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

module "worker" {
  source                   = "./modules/worker"
  instances                = var.worker_node_count
	region                   = var.region
	compartment_ocid         = var.compartment_ocid
  subnet_id                = var.useExistingVcn ? var.privateSubnet : module.network.private-id
	availability_domain      = var.availablity_domain_name
	image_ocid               = data.oci_core_images.InstanceImageOCID-W.images[0].id
  ssh_public_key           = tls_private_key.public_private_key_pair.public_key_openssh 
  ssh_private_key          = tls_private_key.public_private_key_pair.private_key_pem
  worker_instance_shape    = var.worker_instance_shape
  worker_flex_shape_ocpus  = var.worker_flex_shape_ocpus
  worker_flex_shape_memory = var.worker_flex_shape_memory
	block_volumes_per_worker = var.block_volumes_per_worker
	data_blocksize_in_gbs    = var.data_blocksize_in_gbs
  user_data                = base64encode(file("scripts/boot.sh"))
	spark_master             = data.null_data_source.values.outputs["spark_default"]
	block_volume_count       = var.block_volumes_per_worker
  build_mode               = var.build_mode
  hadoop_version           = var.hadoop_version
  use_hive                 = var.use_hive
  spark_version            = var.spark_version
  defined_tags             = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

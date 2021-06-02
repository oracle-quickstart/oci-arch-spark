resource "oci_core_instance" "Worker" {
  count               = var.instances
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  shape               = var.worker_instance_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.worker_flex_shape_memory
      ocpus = var.worker_flex_shape_ocpus
    }
  }

  display_name        = "Spark Worker ${format("%01d", count.index+1)}"
  fault_domain        = "FAULT-DOMAIN-${(count.index%3)+1}"
  defined_tags        = var.defined_tags

  source_details {
    source_type             = "image"
    source_id               = var.image_ocid
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "Spark Worker ${format("%01d", count.index+1)}"
    hostname_label   = "Spark-Worker-${format("%01d", count.index+1)}"
    assign_public_ip = var.hide_public_subnet ? false : true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data		        = var.user_data
    spark_master    	  = var.spark_master
    block_volume_count  = var.block_volume_count
    build_mode       	  = var.build_mode
    hadoop_version      = var.hadoop_version
    use_hive            = var.use_hive 
  }

  timeouts {
    create = "30m"
  }
}
// Block Volume Creation for Worker 
# Data Volumes 
resource "oci_core_volume" "WorkerDataVolume" {
  count               = (var.instances * var.block_volumes_per_worker)
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "Spark Worker ${format("%01d", floor((count.index / var.block_volumes_per_worker)+1))} HDFS Data ${format("%01d", floor((count.index%(var.block_volumes_per_worker))+1))}"
  size_in_gbs         = var.data_blocksize_in_gbs
  defined_tags        = var.defined_tags
}

resource "oci_core_volume_attachment" "WorkerDataAttachment" {
  count           = (var.instances * var.block_volumes_per_worker)
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.Worker[floor(count.index/var.block_volumes_per_worker)].id
  volume_id       = oci_core_volume.WorkerDataVolume[count.index].id
  device          = var.data_volume_attachment_device[floor(count.index%(var.block_volumes_per_worker))]
}


resource "oci_core_instance" "Master" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  shape               = var.master_instance_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.master_flex_shape_memory
      ocpus = var.master_flex_shape_ocpus
    }
  }

  display_name        = "Spark Master"

  source_details {
    source_type             = "image"
    source_id               = var.image_ocid
  }

  create_vnic_details {
    subnet_id         = var.subnet_id
    display_name      = "Spark Master"
    hostname_label    = "Spark-Master"
    assign_public_ip  = var.hide_private_subnet ? true : false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    spark_master	      = var.spark_master
    user_data 		      = var.user_data
    build_mode		      = var.build_mode
    hadoop_version	    = var.hadoop_version
    use_hive		        = var.use_hive
  }

  timeouts {
    create = "30m"
  }
  defined_tags        = var.defined_tags
}



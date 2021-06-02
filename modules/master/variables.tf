# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/oci-quickstart/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "subnet_id" {}
variable "user_data" {}
variable "image_ocid" {}
variable "spark_master" {}
variable "hide_private_subnet" {
  default = "true"
}
variable "build_mode" {}
variable "hadoop_version" {}
variable "use_hive" {}

variable "availability_domain" {
  default = "2"
}

# 
# Set Spark Master Shape in this section
#

variable "master_instance_shape" {
  default = "BM.Standard2.52"
}

variable "master_flex_shape_ocpus" {
  default = 1
}

variable "master_flex_shape_memory" {
  default = 10
}

variable "defined_tags" {
  description = "Defined tags for Spark Master node."
  default     = ""
}

# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Optimized3.Flex",
    "VM.Standard.A1.Flex"
  ]
}

# Checks if is using Flexible Compute Shapes
locals {
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.master_instance_shape)
}
# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/oci-quickstart/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "instances" {}
variable "subnet_id" {}
variable "user_data" {}
variable "image_ocid" {}
variable "spark_master" {}
variable "block_volume_count" {}
variable "hide_public_subnet" {
  default = "true"
}
variable "build_mode" {}
variable "hadoop_version" {}
variable "use_hive" {}
# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# You can modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "availability_domain" {
  default = "2"
}

variable "defined_tags" {
  description = "Defined tags for Spark Worker nodes."
  default     = ""
}

# Number of Workers in the Cluster

variable "worker_node_count" {
  default = "3"
}

variable "data_blocksize_in_gbs" {
  default = "700"
}

# Number of Block Volumes per Worker

variable "block_volumes_per_worker" {
   default = "0"
}
# 
# Set Cluster Shapes in this section
#

variable "worker_instance_shape" {
  default = "BM.Standard2.52"
}

variable "worker_flex_shape_ocpus" {
  default = 1
}

variable "worker_flex_shape_memory" {
  default = 10
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

// Volume Mapping - used to map Worker Block Volumes consistently to the OS
variable "data_volume_attachment_device" {
  type = map
  default = {
    "0" = "/dev/oracleoci/oraclevdd"
    "1" = "/dev/oracleoci/oraclevde"
    "2" = "/dev/oracleoci/oraclevdf"
    "3" = "/dev/oracleoci/oraclevdg"
    "4" = "/dev/oracleoci/oraclevdh"
    "5" = "/dev/oracleoci/oraclevdi"
    "6" = "/dev/oracleoci/oraclevdj"
    "7" = "/dev/oracleoci/oraclevdk"
    "8" = "/dev/oracleoci/oraclevdl"
    "9" = "/dev/oracleoci/oraclevdm"
    "10" = "/dev/oracleoci/oraclevdn"
    "11" = "/dev/oracleoci/oraclevdo"
    "12" = "/dev/oracleoci/oraclevdp"
    "13" = "/dev/oracleoci/oraclevdq"
    "14" = "/dev/oracleoci/oraclevdr" 
    "15" = "/dev/oracleoci/oraclevds"
    "16" = "/dev/oracleoci/oraclevdt"
    "17" = "/dev/oracleoci/oraclevdu"
    "18" = "/dev/oracleoci/oraclevdv"
    "19" = "/dev/oracleoci/oraclevdw"
    "20" = "/dev/oracleoci/oraclevdx"
    "21" = "/dev/oracleoci/oraclevdy"
    "22" = "/dev/oracleoci/oraclevdz"
    "23" = "/dev/oracleoci/oraclevdab"
    "24" = "/dev/oracleoci/oraclevdac"
    "25" = "/dev/oracleoci/oraclevdad"
    "26" = "/dev/oracleoci/oraclevdae" 
    "27" = "/dev/oracleoci/oraclevdaf"
    "28" = "/dev/oracleoci/oraclevdag"
  }
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
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.worker_instance_shape)
}


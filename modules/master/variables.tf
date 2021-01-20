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

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# You can modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "availability_domain" {
  default = "2"
}

# 
# Set Spark Master Shape in this section
#

variable "master_instance_shape" {
  default = "BM.Standard2.52"
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

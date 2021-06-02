## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "user_ocid" {}
variable "availablity_domain_name" {}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.1"
}

variable "useExistingVcn" {
  default = "false"
}
variable "hide_public_subnet" {
  default = "true"
}
variable "hide_private_subnet" {
  default = "true"
}
variable "VCN_CIDR" {
  default = "10.0.0.0/16"
}
variable "myVcn" {
  default = " "
}

variable "privateSubnet" {
  default = " "
}

variable "publicSubnet" {
  default = " "
}

variable "vcn_dns_label" { 
  default = "sparkvcn"
}

variable "hadoop_version" {
  default = "2.7.x"
}

variable "use_hive" {
  default = "false"
}

variable "build_mode" {
  default = "Stand Alone"
}

variable "enable_block_volumes" {
  default = "false"
}

variable "worker_instance_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "worker_flex_shape_ocpus" {
  default = 1
}

variable "worker_flex_shape_memory" {
  default = 10
}

variable "worker_node_count" {
  default = "3"
}

variable "data_blocksize_in_gbs" {
  default = "700"
}

variable "block_volumes_per_worker" {
   default = "1"
}

variable "master_instance_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "master_flex_shape_ocpus" {
  default = 1
}

variable "master_flex_shape_memory" {
  default = 10
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "7.9"
#  default     = "8"
}

locals {
  oci_service_gateway = join("", ["all-", lower(lookup(data.oci_identity_regions.oci_regions.regions[0], "key" )), "-services-in-oracle-services-network"])
}

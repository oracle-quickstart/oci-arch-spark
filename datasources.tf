## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "oci_identity_region_subscriptions" "home_region_subscriptions" {
    tenancy_id = var.tenancy_ocid

    filter {
      name   = "is_home_region"
      values = [true]
    }
}

data "oci_identity_regions" "oci_regions" {
  
  filter {
    name = "name" 
    values = [var.region]
  }

}

# Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID-W" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.worker_instance_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

# Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID-M" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.master_instance_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_vcn" "vcn_info" {
  vcn_id = var.useExistingVcn ? var.myVcn : module.network.vcn-id
}

data "oci_core_subnet" "private_subnet" {
  subnet_id = var.useExistingVcn ? var.privateSubnet : module.network.private-id
}

data "oci_core_subnet" "public_subnet" {
  subnet_id = var.useExistingVcn ? var.publicSubnet : module.network.public-id
}

data "null_data_source" "values" {
  inputs = {
    spark_default = "spark-master.${data.oci_core_subnet.public_subnet.dns_label}.${data.oci_core_vcn.vcn_info.vcn_domain_name}"
  }
}
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
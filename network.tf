## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "network" { 
	source              = "./modules/network"
	tenancy_ocid        = var.tenancy_ocid
	compartment_ocid    = var.compartment_ocid
	availability_domain = var.availablity_domain_name
	region              = var.region
	oci_service_gateway = local.oci_service_gateway
	useExistingVcn      = var.useExistingVcn
  VCN_CIDR            = var.VCN_CIDR
	custom_vcn          = [var.myVcn]
  defined_tags        = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

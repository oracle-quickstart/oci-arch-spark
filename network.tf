module "network" { 
	source              = "./modules/network"
	tenancy_ocid        = var.tenancy_ocid
	compartment_ocid    = var.compartment_ocid
	availability_domain = var.availablity_domain_name
	region              = var.region
	oci_service_gateway = var.oci_service_gateway[var.region]
	useExistingVcn      = var.useExistingVcn
  VCN_CIDR            = var.VCN_CIDR
	custom_vcn          = [var.myVcn]
}

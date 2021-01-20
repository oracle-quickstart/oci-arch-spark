output "vcn-id" {
	value = oci_core_vcn.spark_vcn.0.id
}

output "private-id" {
	value = oci_core_subnet.private.0.id
}

output "public-id" {
  value = oci_core_subnet.public.0.id
}

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "user_ocid" {}
variable "availablity_domain_name" {}

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
  default = "VM.Standard2.1"
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
  default = "VM.Standard2.1"
}

// See https://docs.us-phoenix-1.oraclecloud.com/images/
// Oracle-provided image "Oracle-Linux-7.7-2019.12.18-0"
// Kernel Version: 4.14.35-1902.8.4
variable "InstanceImageOCID" {
  type = map
  default = {
    ap-mumbai-1 = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaka7f3qhfuobx2s7dqfgbcx5klllh5xlflbgzb5pymqsnuphehk2a"
    ap-seoul-1 = "ocid1.image.oc1.ap-seoul-1.aaaaaaaaw52bcejclqwpqchgfx7fhuj4f4smruqxdywwn3uy2xhmhh6bzpza"
    ap-sydney-1 = "ocid1.image.oc1.ap-sydney-1.aaaaaaaazy24niulp5e5a5oyaadjrwnwoa2g6f2hay2f26dqy63pn5sljjma"
    ap-tokyo-1 = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaarl7op6ken6hpevfwuevfnt6ic3tlhitu7pct2py5uxdzyvqb5mkq"
    ca-toronto-1 = "ocid1.image.oc1.ca-toronto-1.aaaaaaaa6wg3hkw7qxwgysuv5c3fuhtyau5cps4ktmjgxvdtxk6ajtf23fcq"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaalljvzqt3aw7cwpls3oqx7dyrcuntqfj6xn3a2ul3jiuby27lqdxa"
    eu-zurich-1 = "ocid1.image.oc1.eu-zurich-1.aaaaaaaaf2fwfgbpxz2g3boettl3q6tow7efs34v2t2t5r45yuydvkqm32ha"
    sa-saopaulo-1 = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaatwrc37cesjtgx3gm4vzq6ocpedgzxjystewc2a7stnv2ydcoiquq"
    uk-london-1 = "ocid1.image.oc1.uk-london-1.aaaaaaaagwdcgcw4squjusjy4yoyzxlewn6omj75f2xur2qpo7dgwexnzyhq"
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaaxrcvnpfxfsyzv3ytuu6swalnbmocneej6yj4nr4vbcoufgmfpwqq"
    us-langley-1 = "ocid1.image.oc2.us-langley-1.aaaaaaaa4uyl37ircuup36ju2l4edrzzjexzvtmzay4yh6bhhgixeojxwo7a"
    us-luke-1 = "ocid1.image.oc2.us-luke-1.aaaaaaaavm4i5dq7m3rvetcgp6ph3gr7if5ew7kmcxvafhgo3hgbw6d2shda"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaactxf4lnfjj6itfnblee3g3uckamdyhqkwfid6wslesdxmlukqvpa"
  }
}

variable "oci_service_gateway" {
  type = map
  default = {
    ap-mumbai-1 = "all-bom-services-in-oracle-services-network"
    ap-seoul-1 = "all-icn-services-in-oracle-services-network"
    ap-sydney-1 = "all-syd-services-in-oracle-services-network"
    ap-tokyo-1 = "all-nrt-services-in-oracle-serviecs-network"
    ca-toronto-1 = "all-yyz-services-in-oracle-services-network"
    eu-frankfurt-1 = "all-fra-services-in-oracle-services-network"
    eu-zurich-1 = "all-zrh-services-in-oracle-services-network"
    sa-saopaulo-1 = "all-gru-services-in-oracle-services-network"
    uk-london-1 = "all-lhr-services-in-oracle-services-network"
    us-ashburn-1 = "all-iad-services-in-oracle-services-network"
    us-langley-1 = "all-lfi-services-in-oracle-services-network"
    us-luke-1 = "all-luf-services-in-oracle-services-network"
    us-phoenix-1 = "all-phx-services-in-oracle-services-network"
  }
}

variable "nic_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "name" {}
variable "vm_size" {}
variable "image_publisher" {}
variable "image_offer" {}
variable "Image_sku" {}
variable "Image_version" {}
variable "subnet_name" {
    type = string
}
variable "public_ip_name" {}
# variable "subnet" {}
variable "vnet" {}
variable "admin_username" {}
variable "admin_password" {}
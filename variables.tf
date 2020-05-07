variable "os_image" {
  default = "ubuntu-18.04"
}

variable "private_key_path" {
  type    = string
}

variable "public_key_path" {
  type    = list(string)
}

variable "vm_count" {
  type = number
  default = "1"  
}

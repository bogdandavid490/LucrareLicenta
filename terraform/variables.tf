variable "ami_id" {
  description = "ID-ul AMI generat cu Packer"
  type        = string
}

variable "key_name" {
  description = "Numele perechii de chei pentru SSH"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID în care va fi lansată instanța"
  type        = string
}

variable "security_group_id" {
  description = "Grup de securitate pentru instanță"
  type        = string
}


variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}


variable "public_key" {
  description = "The SSH public key"
  type        = string
}

variable "private_key_path" {
  description = "The path to the private key for SSH access"
  type        = string
}
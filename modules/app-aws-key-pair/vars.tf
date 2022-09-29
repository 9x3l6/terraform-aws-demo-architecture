variable "app-aws-key-pair-key-name" {
  description = "SSH key pair name having access to bastion host"
  default = "terraform-aws-demo-architecture"
}

variable "app-aws-key-pair-public-key-path" {
  description = "SSH key pair public key path having access to bastion host"
  default = ".terraform-aws-demo-architecture-key-pair"
}
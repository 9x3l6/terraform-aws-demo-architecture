resource "aws_key_pair" "app-aws-key-pair" {
  key_name   = var.app-aws-key-pair-key-name
  public_key = file(var.app-aws-key-pair-public-key-path)  
}

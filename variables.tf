variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-1"
}

variable "additional_ips" {
  type        = list(string)
  description = "List of Additional IPs to allow. CIDR Format : X.X.X.X/X"
  default     = []
}

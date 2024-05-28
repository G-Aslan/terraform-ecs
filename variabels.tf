variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  default     = "ZeY7fj9+"
}

variable "aws_session_token" {
  description = "AWS Session Token (if using temporary credentials)"
  type        = string
  default     = ""
}

variable "region" {
  default = "us-east-1"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "aws_account_id" {
  default = "292029882946"
}
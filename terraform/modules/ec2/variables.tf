variable "instance_type" {
  description = "インスタンスタイプ"
  type        = string
  default     = "t3.small"
}

variable "domain" {
  description = "ドメイン"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "public_subnet_id" {
  description = "パブリックサブネットID"
  type        = string
}

variable "load_balancer_security_group_id" {
  description = "ロードバランサーのセキュリティグループID"
  type        = string
}
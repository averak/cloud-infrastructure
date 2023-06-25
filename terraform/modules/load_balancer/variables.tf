variable "domain" {
  description = "ドメイン"
  type        = string
}

variable "ec2_instance_id" {
  description = "トラフィックのforward先になるEC2のインスタンスID"
  type        = string
}

variable "certificate_arn" {
  description = "SSL証明書のARN"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "public_subnet_ids" {
  description = "パブリックサブネットIDリスト"
  type        = list(string)
}
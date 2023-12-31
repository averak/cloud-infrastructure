variable "domain" {
  description = "ドメイン"
  type        = string
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZリスト"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "public_subnet_cidrs" {
  description = "パブリックサブネットのCIDRブロックリスト"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

#variable "private_subnet_cidrs" {
#  description = "プライベートサブネットのCIDRブロックリスト"
#  type        = list(string)
#  default     = ["10.0.101.0/24", "10.0.102.0/24"]
#}

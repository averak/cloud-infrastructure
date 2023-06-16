output "certificate_arn" {
  description = "SSL証明書のARN"
  value       = aws_acm_certificate.main.arn
}
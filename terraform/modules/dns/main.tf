resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "cert_validations" {
  count = length(aws_acm_certificate.main.domain_validation_options)

  zone_id         = aws_route53_zone.main.zone_id
  name            = aws_acm_certificate.main.domain_validation_options[count.index].resource_record_name
  type            = aws_acm_certificate.main.domain_validation_options[count.index].resource_record_type
  records         = [aws_acm_certificate.main.domain_validation_options[count.index].resource_record_value]
  ttl             = 3600
  allow_overwrite = true
}

resource "aws_acm_certificate" "main" {
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = aws_route53_record.cert_validations[*].fqdn
}
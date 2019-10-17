resource "aws_acm_certificate" "evermos_com" {
  domain_name = "evermos.com"
  subject_alternative_names = [
    "*.evermos.com",
  ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "evermos_com_cert_validation" {
  name    = aws_acm_certificate.evermos_com.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.evermos_com.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.evm.id
  records = [aws_acm_certificate.evermos_com.domain_validation_options.0.resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "evermos_com" {
  certificate_arn         = aws_acm_certificate.evermos_com.arn
  validation_record_fqdns = [aws_route53_record.evermos_com_cert_validation.fqdn]
}

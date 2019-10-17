# Staging
resource "aws_instance" "all_stag" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.medium"
  key_name      = "evermos"
  tags = {
    Name = "all_stag"
    Type = "stag"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
    aws_security_group.midtrans.id,
    aws_security_group.doku.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "staging_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.private_ip]
}

# Evermos Staging
resource "aws_route53_record" "evm_fe_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

resource "aws_route53_record" "evm_fe_stag_apex" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = ""
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

resource "aws_route53_record" "evm_be_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "api.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

resource "aws_route53_record" "evm_stag_hook" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "webhook.${aws_route53_record.evm_fe_stag.name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_route53_record.evm_fe_stag.fqdn]
}

# Berikhtiar Staging
resource "aws_route53_record" "itr_fe_stag" {
  zone_id = aws_route53_zone._itr.zone_id
  name    = "staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

resource "aws_route53_record" "itr_be_stag" {
  zone_id = aws_route53_zone._itr.zone_id
  name    = "api.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

# Zoya Staging
resource "aws_route53_record" "zoy_fe_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "zoya.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

# Evermos Admin Staging
resource "aws_route53_record" "eva_fe_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "admin.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

resource "aws_route53_record" "eva_be_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "api-admin.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

# Wakaf Staging
resource "aws_route53_record" "wkf_fe_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "wakaf.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

resource "aws_route53_record" "wkf_be_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "api-wakaf.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

# Payment Staging
resource "aws_route53_record" "pay_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "payment.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

# Flashsale Staging
resource "aws_route53_record" "flashsale_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "flashsale.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

# Finance Staging
resource "aws_route53_record" "fin_be_stag" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "finance.staging"
  type    = "A"
  ttl     = 300
  records = [aws_instance.all_stag.public_ip]
}

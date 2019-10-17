# Evermos Frontend
resource "aws_instance" "evm_fe_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "evermos-fe"
  tags = {
    Name = "evm-fe-prod"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "evm_fe_prod" {
  zone_id = aws_route53_zone.evm.zone_id
  name    = ""
  type    = "A"
  ttl     = 300
  records = [aws_instance.evm_fe_prod.public_ip]
}

resource "aws_route53_record" "evm_fe_prod_www" {
  zone_id = aws_route53_zone.evm.zone_id
  name    = "www"
  type    = "A"
  ttl     = 300
  records = [aws_instance.evm_fe_prod.public_ip]
}

resource "aws_route53_record" "evermos_fe_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "evermos-fe"
  type    = "A"
  ttl     = 300
  records = [aws_instance.evm_fe_prod.private_ip]
}

resource "aws_route53_record" "evermos_fe_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "ef"
  type    = "A"
  ttl     = 300
  records = [aws_instance.evm_fe_prod.private_ip]
}

#resource "aws_route53_record" "evm-fe-prod-hook" {
#  zone_id = aws_route53_zone.evm.zone_id
#  name = "webhook"
#  type = "CNAME"
#  ttl = 300
#  records = [aws_route53_record.evm-fe-prod.fqdn]
#}

# Evermos Backend
resource "aws_instance" "evm_be_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "evermos"
  tags = {
    Name = "evm-be-prod"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
    aws_security_group.midtrans.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "evm_be_prod" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "api.web"
  type    = "A"
  ttl     = 300
  records = [aws_instance.evm_be_prod.public_ip]
}

resource "aws_route53_record" "evermos_be_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "evermos-be"
  type    = "A"
  ttl     = 300
  records = [aws_instance.evm_be_prod.private_ip]
}

resource "aws_route53_record" "evermos_be_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "eb"
  type    = "A"
  ttl     = 300
  records = [aws_instance.evm_be_prod.private_ip]
}


# Evermos Backend Android
resource "aws_instance" "evm_be_prod_and" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.small"
  key_name      = "evermos"
  tags = {
    Name = "evm-be-prod-and"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
    aws_security_group.midtrans.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "evm_be_prod_and" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "api.android"
  type    = "A"
  ttl     = 300
  records = [aws_eip.evm_be_prod_and0.public_ip]
}

resource "aws_route53_record" "evermos_be_android_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "evermos-be-android"
  type    = "A"
  ttl     = 300
  records = [aws_eip.evm_be_prod_and0.private_ip]
}

resource "aws_route53_record" "evermos_be_android_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "eba"
  type    = "A"
  ttl     = 300
  records = [aws_eip.evm_be_prod_and0.private_ip]
}

# Evermos Backend Android 0
resource "aws_instance" "evm_be_prod_and0" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "evermos"
  tags = {
    Name = "evm-be-prod-and0"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
    aws_security_group.midtrans.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_eip" "evm_be_prod_and0" {
  instance = aws_instance.evm_be_prod_and0.id
}

resource "aws_route53_record" "evm_be_prod_and0" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "api0.android"
  type    = "A"
  ttl     = 300
  records = [aws_eip.evm_be_prod_and0.public_ip]
}

resource "aws_route53_record" "evermos_be_android0_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "evermos-be-android0"
  type    = "A"
  ttl     = 300
  records = [aws_eip.evm_be_prod_and0.private_ip]
}

resource "aws_route53_record" "evermos_be_android0_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "eba0"
  type    = "A"
  ttl     = 300
  records = [aws_eip.evm_be_prod_and0.private_ip]
}

# Evermos Payment
resource "aws_instance" "pay_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "evermos"
  tags = {
    Name = "pay_prod"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
    aws_security_group.midtrans.id,
    aws_security_group.doku.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "pay_prod" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "payment"
  type    = "A"
  ttl     = 300
  records = [aws_instance.pay_prod.public_ip]
}

resource "aws_route53_record" "pay_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "payment"
  type    = "A"
  ttl     = 300
  records = [aws_instance.pay_prod.private_ip]
}

# Evermos Flashsale
resource "aws_instance" "flashsale_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "evermos"
  tags = {
    Name = "flashsale_prod"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "flashsale_prod" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "flashsale"
  type    = "A"
  ttl     = 300
  records = [aws_instance.flashsale_prod.public_ip]
}

resource "aws_route53_record" "flashsale_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "flashsale"
  type    = "A"
  ttl     = 300
  records = [aws_instance.flashsale_prod.private_ip]
}

#resource "aws_route53_record" "evm-be-prod-hook" {
#  zone_id = aws_route53_zone._evm.zone_id
#  name = "webhook.${aws_route53_record.evm-be-prod.name}"
#  type = "CNAME"
#  ttl = 300
#  records = [aws_route53_record.evm-be-prod.fqdn]
#}

# Evermos Admin Frontend
resource "aws_instance" "eva_fe_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "evermos-admin-fe"
  tags = {
    Name = "eva-fe-prod"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "eva_fe_prod" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "admin"
  type    = "A"
  ttl     = 300
  records = [aws_instance.eva_fe_prod.public_ip]
}

resource "aws_route53_record" "eva_fe_prod_mimin" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "mimin"
  type    = "A"
  ttl     = 300
  records = [aws_instance.eva_fe_prod.public_ip]
}

resource "aws_route53_record" "admin_fe_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "evermos-admin-fe"
  type    = "A"
  ttl     = 300
  records = [aws_instance.eva_fe_prod.private_ip]
}

resource "aws_route53_record" "admin_fe_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "af"
  type    = "A"
  ttl     = 300
  records = [aws_instance.eva_fe_prod.private_ip]
}

#resource "aws_route53_record" "eva-fe-prod-hook" {
#  zone_id = aws_route53_zone._evm.zone_id
#  name = "webhook.${aws_route53_record.eva-fe-prod.name}"
#  type = "CNAME"
#  ttl = 300
#  records = [aws_route53_record.eva-fe-prod.fqdn]
#}

# Evermos Admin Backend
resource "aws_instance" "eva_be_prod_old" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "evermos-admin-be"

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_instance" "eva_be_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.micro"
  key_name      = "evermos"
  tags = {
    Name = "eva-be-prod"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "eva_be_prod" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "api.admin"
  type    = "A"
  ttl     = 300
  records = [aws_instance.eva_be_prod.public_ip]
}

resource "aws_route53_record" "admin_be_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "evermos-admin-be"
  type    = "A"
  ttl     = 300
  records = [aws_instance.eva_be_prod.private_ip]
}

resource "aws_route53_record" "admin_be_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "ab"
  type    = "A"
  ttl     = 300
  records = [aws_instance.eva_be_prod.private_ip]
}

#resource "aws_route53_record" "eva-be-prod-hook" {
#  zone_id = aws_route53_zone._evm.zone_id
#  name = "webhook.${aws_route53_record.eva-be-prod.name}"
#  type = "CNAME"
#  ttl = 300
#  records = [aws_route53_record.eva-be-prod.fqdn]
#}

# Berikhtiar Frontend
resource "aws_instance" "itr_fe_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "evermos"
  tags = {
    Name = "itr-fe-prod"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_instance" "itr_fe_prod0" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = "evermos"
  tags = {
    Name = "itr-fe-prod0"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "itr_fe_prod" {
  zone_id = aws_route53_zone.itr.zone_id
  name    = ""
  type    = "A"
  ttl     = 300
  records = [aws_instance.itr_fe_prod0.public_ip]
}

resource "aws_route53_record" "itr_fe_prod_www" {
  zone_id = aws_route53_zone.itr.zone_id
  name    = "www"
  type    = "A"
  ttl     = 300
  records = [aws_instance.itr_fe_prod0.public_ip]
}

resource "aws_route53_record" "ikhtiar_fe_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "berikhtiar-fe"
  type    = "A"
  ttl     = 300
  records = [aws_instance.itr_fe_prod0.private_ip]
}

resource "aws_route53_record" "ikhtiar_fe_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "if"
  type    = "A"
  ttl     = 300
  records = [aws_instance.itr_fe_prod0.private_ip]
}

# Shafco Frontend
resource "aws_instance" "zoy_fe" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.micro"
  key_name      = "evermos"
  tags = {
    Name = "zoy_fe"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "zoy_fe" {
  zone_id = aws_route53_zone.zoy.zone_id
  name    = ""
  type    = "A"
  ttl     = 300
  records = [aws_instance.zoy_fe.public_ip]
}

resource "aws_route53_record" "zoy_fe_www" {
  zone_id = aws_route53_zone.zoy.zone_id
  name    = "www"
  type    = "A"
  ttl     = 300
  records = [aws_instance.zoy_fe.public_ip]
}

#resource "aws_route53_record" "itr-fe-prod-hook" {
#  zone_id = "aws_route53_zone.itr.zone_id"
#  name = "webhook"
#  type = "CNAME"
#  ttl = 300
#  records = [aws_route53_record.itr-fe-prod.fqdn]
#}

# Berikhtiar Backend
resource "aws_instance" "itr_be_prod1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name      = "evermos"
  tags = {
    Name = "itr-be-prod1"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
    aws_security_group.midtrans.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "itr_be_prod" {
  zone_id = aws_route53_zone._itr.zone_id
  name    = "api.web"
  type    = "A"
  ttl     = 300
  records = [
    aws_instance.itr_be_prod1.public_ip,
  ]
}

resource "aws_route53_record" "ikhtiar_be_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "berikhtiar-be"
  type    = "A"
  ttl     = 300
  records = [
    aws_instance.itr_be_prod1.private_ip,
  ]
}

resource "aws_route53_record" "ikhtiar_be_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "ib"
  type    = "A"
  ttl     = 300
  records = [
    aws_instance.itr_be_prod1.private_ip,
  ]
}

#resource "aws_route53_record" "itr-be-prod-hook" {
#  zone_id = aws_route53_zone._itr.zone_id
#  name = "webhook.${aws_route53_record.itr-be-prod.name}"
#  type = "CNAME"
#  ttl = 300
#  records = [aws_route53_record.itr-be-prod.fqdn]
#}

# Beramal Jariyah Frontend
resource "aws_instance" "baj_fe_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "evermos"
  tags = {
    Name = "baj-fe-prod"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "baj" {
  zone_id = aws_route53_zone.baj.zone_id
  name    = ""
  type    = "A"
  ttl     = 300
  records = [aws_instance.baj_fe_prod.public_ip]
}

resource "aws_route53_record" "baj_www" {
  zone_id = aws_route53_zone.baj.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  records = [aws_route53_record.baj.fqdn]
}

resource "aws_route53_record" "bajcom" {
  zone_id = aws_route53_zone.bajcom.zone_id
  name    = ""
  type    = "A"
  ttl     = 300
  records = [aws_instance.baj_fe_prod.public_ip]
}

resource "aws_route53_record" "bajcom_www" {
  zone_id = aws_route53_zone.bajcom.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  records = [aws_route53_record.baj.fqdn]
}

resource "aws_route53_record" "baj_fe_prod_hook" {
  zone_id = aws_route53_zone.baj.zone_id
  name    = "webhook"
  type    = "CNAME"
  ttl     = 300
  records = [aws_route53_record.baj.fqdn]
}

resource "aws_route53_record" "wakaf_fe_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "wakaf-fe"
  type    = "A"
  ttl     = 300
  records = [aws_instance.baj_fe_prod.private_ip]
}

resource "aws_route53_record" "wakaf_fe_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "wf"
  type    = "A"
  ttl     = 300
  records = [aws_instance.baj_fe_prod.private_ip]
}

# Wakaf Backend
resource "aws_instance" "wkf_be_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "evermos"
  tags = {
    Name = "wkf-be-prod"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "wkf_be_prod" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "api.wakaf"
  type    = "A"
  ttl     = 300
  records = [aws_instance.wkf_be_prod.public_ip]
}

resource "aws_route53_record" "wakaf_be_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "wakaf-be"
  type    = "A"
  ttl     = 300
  records = [aws_instance.wkf_be_prod.private_ip]
}

resource "aws_route53_record" "wakaf_be_short_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "wb"
  type    = "A"
  ttl     = 300
  records = [aws_instance.wkf_be_prod.private_ip]
}

#resource "aws_route53_record" "wkf-be-prod-hook" {
#  zone_id = aws_route53_zone._evm.zone_id
#  name = "webhook-${aws_route53_record.wkf-be-prod.name}"
#  type = "CNAME"
#  ttl = 300
#  records = [aws_route53_record.wkf-be-prod.fqdn]
#}

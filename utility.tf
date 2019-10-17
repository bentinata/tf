variable "postgres_password_kong" {}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.nano"
  key_name      = "evermos"
  tags = {
    Name = "bastion"
    Type = "util"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.bastion.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
}

resource "aws_instance" "status" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "evermos"
  tags = {
    Name = "status"
    Type = "util"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "status" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "status"
  type    = "A"
  ttl     = 300
  records = [aws_instance.status.public_ip]
}

resource "aws_route53_record" "status_hook" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "webhook.${aws_route53_record.status.name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_route53_record.status.fqdn]
}

resource "aws_instance" "phabricator" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.micro"
  key_name      = "evermos"
  tags = {
    Name = "phabricator"
    Type = "util"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "phabricator" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "phabricator"
  type    = "A"
  ttl     = 300
  records = [aws_instance.phabricator.public_ip]
}

resource "aws_instance" "kong" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = "evermos"
  tags = {
    Name = "kong"
    Type = "util"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_eip" "kong" {
  instance = aws_instance.kong.id
  vpc      = true
}

resource "aws_route53_record" "kong" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "kong"
  type    = "A"
  ttl     = 300
  records = [aws_eip.kong.public_ip]
}

resource "aws_route53_record" "kong_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "kong"
  type    = "A"
  ttl     = 300
  records = [aws_eip.kong.private_ip]
}

resource "aws_db_instance" "kong" {
  identifier          = "kong"
  apply_immediately   = true
  allocated_storage   = 10
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "11.4"
  instance_class      = "db.t3.micro"
  name                = "kong"
  username            = "root"
  password            = var.postgres_password_kong
  publicly_accessible = true

  vpc_security_group_ids = [
    aws_security_group.default.id,
  ]
}

resource "aws_route53_record" "metabase" {
  zone_id = aws_route53_zone.evm.zone_id
  name    = "metabase"
  type    = "CNAME"
  ttl     = 300
  records = ["evermos-metabase.ap-southeast-1.elasticbeanstalk.com"]
}

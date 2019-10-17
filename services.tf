# Visitor Notification
resource "aws_instance" "svc_visitnotif" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "evermos"
  tags = {
    Name = "svc-visitnotif"
    Type = "prod"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http_public.id,
  ]

  lifecycle { ignore_changes = [ami] }
}

resource "aws_route53_record" "svc_visitnotif" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "notif"
  type    = "A"
  ttl     = 300
  records = [aws_instance.svc_visitnotif.public_ip]
}

resource "aws_route53_record" "svc_visitor_notification_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "notification"
  type    = "A"
  ttl     = 300
  records = [aws_instance.svc_visitnotif.private_ip]
}

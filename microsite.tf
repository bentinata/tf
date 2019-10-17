variable "mariadb_password_wordpress" {}

resource "aws_db_instance" "wordpress" {
  identifier          = "wordpress"
  apply_immediately   = true
  allocated_storage   = 10
  storage_type        = "gp2"
  engine              = "mariadb"
  engine_version      = "10.3"
  instance_class      = "db.t3.micro"
  username            = "root"
  password            = var.mariadb_password_wordpress
  publicly_accessible = false

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.lightsail.id,
  ]
}

# Blog Beramaljariyah
resource "aws_lightsail_instance" "blog_beramaljariyah" {
  name              = "blog.beramaljariyah.org"
  availability_zone = "ap-southeast-1a"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "micro_2_0"
  key_pair_name     = "evermos"

  #  tags = {
  #    Name = "wp-wkf"
  #    Type = "prod"
  #  }
}

resource "aws_lightsail_static_ip" "blog_beramaljariyah" {
  name = "blog.beramaljariyah.org-static"
}

resource "aws_lightsail_static_ip_attachment" "blog_beramaljariyah" {
  static_ip_name = aws_lightsail_static_ip.blog_beramaljariyah.name
  instance_name  = aws_lightsail_instance.blog_beramaljariyah.name
}

resource "aws_route53_record" "baj_blog" {
  zone_id = aws_route53_zone.baj.zone_id
  name    = "blog"
  type    = "A"
  ttl     = 3600
  records = [aws_lightsail_static_ip.blog_beramaljariyah.ip_address]
}


# Reseller Evermos
resource "aws_lightsail_instance" "resellerevermos" {
  name              = "resellerevermos.com"
  availability_zone = "ap-southeast-1a"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "micro_2_0"
  key_pair_name     = "evermos"

  #  tags = {
  #    Name = "wp-re"
  #    Type = "prod"
  #  }
}

resource "aws_lightsail_static_ip" "resellerevermos" {
  name = "resellerevermos.com-static"
}

resource "aws_lightsail_static_ip_attachment" "resellerevermos" {
  static_ip_name = aws_lightsail_static_ip.resellerevermos.name
  instance_name  = aws_lightsail_instance.resellerevermos.name
}

# Reseller Kaya
resource "aws_lightsail_instance" "resellerkaya" {
  name              = "resellerkaya.com"
  availability_zone = "ap-southeast-1a"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "micro_2_0"
  key_pair_name     = "evermos"

  #  tags = {
  #    Name = "wp-rk"
  #    Type = "prod"
  #  }
}

resource "aws_lightsail_static_ip" "resellerkaya" {
  name = "resellerkaya.com-static"
}

resource "aws_lightsail_static_ip_attachment" "resellerkaya" {
  static_ip_name = aws_lightsail_static_ip.resellerkaya.name
  instance_name  = aws_lightsail_instance.resellerkaya.name
}

# Reseller Evermos
resource "aws_lightsail_instance" "resellerindonesia" {
  name              = "reseller-indonesia.com"
  availability_zone = "ap-southeast-1a"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "micro_2_0"
  key_pair_name     = "evermos"

  #  tags = {
  #    Name = "wp-ri"
  #    Type = "prod"
  #  }
}

resource "aws_lightsail_static_ip" "resellerindonesia" {
  name = "reseller-indonesia.com-static"
}

resource "aws_lightsail_static_ip_attachment" "resellerindonesia" {
  static_ip_name = aws_lightsail_static_ip.resellerindonesia.name
  instance_name  = aws_lightsail_instance.resellerindonesia.name
}

# WordPress Multipurpose Site
resource "aws_lightsail_instance" "wordpress" {
  name              = "wordpress"
  availability_zone = "ap-southeast-1a"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "micro_2_0"
  key_pair_name     = "evermos"

  #  tags = {
  #    Name = "wp-ri"
  #    Type = "prod"
  #  }
}

resource "aws_lightsail_static_ip" "wordpress" {
  name = "wordpress-static"
}

resource "aws_lightsail_static_ip_attachment" "wordpress" {
  static_ip_name = aws_lightsail_static_ip.wordpress.name
  instance_name  = aws_lightsail_instance.wordpress.name
}

# Content Evermos
resource "aws_route53_record" "content_evermos" {
  zone_id = aws_route53_zone.evm.zone_id
  name    = "content"
  type    = "A"
  ttl     = 300
  records = [aws_lightsail_static_ip.wordpress.ip_address]
}

# Contoh Evermos
resource "aws_route53_record" "contoh_evermos" {
  zone_id = aws_route53_zone.evm.zone_id
  name    = "contoh"
  type    = "A"
  ttl     = 300
  records = [aws_instance.evm_fe_prod.public_ip]
}

# Maujadireseller
resource "aws_route53_record" "maujadireseller" {
  zone_id = aws_route53_zone.maujadireseller_com.zone_id
  name    = ""
  type    = "A"
  ttl     = 3600
  records = [aws_lightsail_static_ip.wordpress.ip_address]
}

resource "aws_route53_record" "www_maujadireseller" {
  zone_id = aws_route53_zone.maujadireseller_com.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 3600
  records = [aws_route53_record.maujadireseller.fqdn]
}

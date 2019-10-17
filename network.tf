resource "aws_vpc" "default" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_subnet" "a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.31.32.0/20"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "b" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.31.16.0/20"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "c" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.31.0.0/20"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "default" {
  name        = "default"
  description = "default VPC security group"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.dns_a_record_set.office-sampoerna.addrs[0]}/32"]
    description = "SSH from Evermos"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = true
    description = "SSH from internal network"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["${data.dns_a_record_set.office-sampoerna.addrs[0]}/32"]
    description = "HTTP from Evermos"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["${data.dns_a_record_set.office-sampoerna.addrs[0]}/32"]
    description = "HTTPS from Evermos"
  }

  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["${data.dns_a_record_set.office-sampoerna.addrs[0]}/32"]
    description = "Non-root port from Evermos"
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ping"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
    ]
    description = "Remote"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All network out"
  }
}

resource "aws_security_group" "http_public" {
  name        = "http_public"
  description = "Allow http access from the internet. For public facing server."
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from internet"
  }
}

resource "aws_security_group" "midtrans" {
  name        = "midtrans"
  description = "Allow access from Midtrans server."
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "103.208.23.0/24",
      "103.208.23.6/32",
      "182.253.221.152/32",
      "103.127.16.0/23",
      "103.127.17.6/32",
      "103.58.103.177/32",
    ]
    description = "HTTP from Midtrans"
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "103.208.23.0/24",
      "103.208.23.6/32",
      "182.253.221.152/32",
      "103.127.16.0/23",
      "103.127.17.6/32",
      "103.58.103.177/32",
    ]
    description = "HTTPS from Midtrans"
  }
}

resource "aws_security_group" "doku" {
  name        = "doku"
  description = "Allow access from Doku server."
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      # Akamai
      "23.8.101.109/32",
      "23.38.211.82/32",
      "23.72.22.84/32",
      "23.74.12.58/32",
      "184.27.16.109/32",
      "184.86.25.247/32",

      # Doku Production
      "104.74.31.7/32",
      "104.95.20.191/32",
      "104.105.143.98/32",
      "103.10.129.9/32",
      "103.10.130.35/32",

      # Doku Development
      "103.10.129.16/32",
    ]
    description = "HTTP from Doku"
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      # Akamai
      "23.8.101.109/32",
      "23.38.211.82/32",
      "23.72.22.84/32",
      "23.74.12.58/32",
      "184.27.16.109/32",
      "184.86.25.247/32",

      # Doku Production
      "104.74.31.7/32",
      "104.95.20.191/32",
      "104.105.143.98/32",
      "103.10.129.9/32",
      "103.10.130.35/32",

      # Doku Development
      "103.10.129.16/32",
    ]
    description = "HTTPS from Doku"
  }
}

resource "aws_security_group" "lightsail" {
  name        = "lightsail"
  description = "Allow access from Lightsail"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [
      "${aws_lightsail_instance.wordpress.private_ip_address}/32",
      "${aws_lightsail_instance.blog_beramaljariyah.private_ip_address}/32",
      "${aws_lightsail_instance.resellerevermos.private_ip_address}/32",
      "${aws_lightsail_instance.resellerkaya.private_ip_address}/32",
    ]
    description = "MySQL from Lightsail"
  }
}

resource "aws_security_group" "anywhere" {
  name        = "anywhere"
  description = "Allow access from anywhere"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description = "MySQL from anywhere"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH from everywhere."
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH from everywhere"
  }
}

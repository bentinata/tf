data "aws_ami" "arch" {
  most_recent = true

  filter {
    name   = "name"
    values = ["arch-linux-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  # Uplink Labs
  owners = ["093273469852"]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  # Canonical
  owners = ["099720109477"]
}

data "aws_ami" "ubuntu_minimal" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-bionic-18.04-amd64-minimal-*"]
  }

  owners = ["099720109477"]
}

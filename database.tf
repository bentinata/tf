variable "mariadb_password_production" {}
variable "mariadb_password_staging" {}
variable "mariadb_password_phabricator" {}
variable "mariadb_password_statistic" {}

resource "aws_route53_record" "db_production" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.evermos_production.address]
}

resource "aws_route53_record" "db_production_replica_1" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "db-rep1"
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.evermos_production_replica.address]
}

resource "aws_route53_record" "db_production_replica_2" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "db-rep2"
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.evermos_production_replica.address]
}

resource "aws_db_instance" "statistic_master_production" {
  identifier          = "stt"
  apply_immediately   = true
  allocated_storage   = 10
  storage_type        = "gp2"
  engine              = "mariadb"
  engine_version      = "10.3"
  instance_class      = "db.t3.micro"
  name                = "evermos"
  username            = "root"
  password            = var.mariadb_password_statistic
  publicly_accessible = true
}

resource "aws_db_instance" "evermos_production" {
  identifier              = "evm-prod"
  apply_immediately       = true
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mariadb"
  engine_version          = "10.3"
  instance_class          = "db.t3.medium"
  name                    = "evermos"
  username                = "root"
  password                = var.mariadb_password_production
  backup_retention_period = 7
  publicly_accessible     = true

  vpc_security_group_ids = [
    aws_security_group.default.id,
  ]
}

resource "aws_db_instance" "evermos_production_replica" {
  identifier          = "evm-prod-rep"
  apply_immediately   = true
  storage_type        = "gp2"
  instance_class      = "db.t3.medium"
  name                = "evermos"
  publicly_accessible = true
  replicate_source_db = aws_db_instance.evermos_production.identifier

  vpc_security_group_ids = [
    aws_security_group.default.id,
  ]
}

resource "aws_db_instance" "evermos_staging" {
  identifier              = "evm-stag"
  apply_immediately       = true
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mariadb"
  engine_version          = "10.3"
  instance_class          = "db.t3.micro"
  name                    = "evermos"
  username                = "root"
  password                = var.mariadb_password_staging
  backup_retention_period = 1
  publicly_accessible     = true

  vpc_security_group_ids = [
    aws_security_group.default.id,
  ]
}

resource "aws_route53_record" "db_staging" {
  zone_id = aws_route53_zone._evm.zone_id
  name    = "db.staging"
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.evermos_staging.address]
}

resource "aws_db_instance" "phabricator" {
  apply_immediately   = true
  allocated_storage   = 10
  storage_type        = "gp2"
  engine              = "mariadb"
  engine_version      = "10.3"
  instance_class      = "db.t2.micro"
  name                = "phabricator"
  username            = "phabricator"
  password            = var.mariadb_password_phabricator
  publicly_accessible = true

  parameter_group_name = aws_db_parameter_group.phabricator.name
}

resource "aws_db_parameter_group" "phabricator" {
  family = "mariadb10.3"

  parameter {
    name  = "max_allowed_packet"
    value = 33554432
  }

  parameter {
    name  = "sql_mode"
    value = "strict_all_tables"
  }

  parameter {
    name  = "local_infile"
    value = 0
  }
}

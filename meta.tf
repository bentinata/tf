variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  region = "ap-southeast-1"
}

resource "aws_route53_zone" "evm" {
  name = "evermos.com"
}

resource "aws_route53_zone" "_evm" {
  name = "evermosa2z.com"
}

resource "aws_route53_zone" "itr" {
  name = "berikhtiar.com"
}

resource "aws_route53_zone" "_itr" {
  name = "berikhtiara2z.com"
}

resource "aws_route53_zone" "baj" {
  name = "beramaljariyah.org"
}

resource "aws_route53_zone" "bajcom" {
  name = "beramaljariyah.com"
}

resource "aws_route53_zone" "zoy" {
  name = "zoyareseller.com"
}

resource "aws_route53_zone" "resellerevermos_com" {
  name = "resellerevermos.com"
}

resource "aws_route53_zone" "resellerkaya_com" {
  name = "resellerkaya.com"
}

resource "aws_route53_zone" "resellerindonesia_com" {
  name = "reseller-indonesia.com"
}

resource "aws_route53_zone" "maujadireseller_com" {
  name = "maujadireseller.com"
}

resource "aws_route53_zone" "internal" {
  name = "internal"
  vpc {
    vpc_id = aws_vpc.default.id
  }
}

provider "google" {
  project = "evermos-221008"
  region  = "asia-southeast1"
}

data "dns_a_record_set" "office-sampoerna" {
  host = "evermos.duckdns.org"
}

resource "aws_route53_record" "evm_google_dkim" {
  zone_id = aws_route53_zone.evm.zone_id
  name    = "google._domainkey"
  type    = "TXT"
  ttl     = 3600
  records = ["v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApNHkxZfyiJ5m2+OjN0TtvgF/uzK83IVzBsDCC2HFdmGYNdmB2cbD4B6qZhGrXrGSprH8ZuWGiP+ZT/qxpu6+KHSTwLl2lfIUIPB8YbCvsWCE2w4ElnLUWrZfrR1Xg+1\"\"crwnJST3mPhFZzC3yCwZnwjuJECBHsibjuNVxqyiEShKlBqNubv5doHt6llkO7jqLc0E8y78gekmqWV1Om/dGLmlWdq5AlFYHUu6hscWSu0t12MwWHFKdb9pI6ryyukUqLEVLIUVURX1zgUtNuzxZ1+3sIFJ0e6iLAgBM1/TYxCN8gJDWXQD+mwa7kYBscQMRX0psRYNJ4CvHf3LHwENzeQIDAQAB"]
}

resource "aws_route53_record" "evm_dmarc" {
  zone_id = aws_route53_zone.evm.zone_id
  name    = "_dmarc"
  type    = "TXT"
  ttl     = 3600
  records = ["v=DMARC1; p=none; pct=100; rua=mailto:re+snl9rw4h3yq@dmarc.postmarkapp.com; sp=none; aspf=r;"]
}

resource "aws_route53_record" "evm_txt" {
  zone_id = aws_route53_zone.evm.zone_id
  name    = ""
  type    = "TXT"
  ttl     = 3600
  records = [
    "facebook-domain-verification=n53n09ggur2yf1coku7d9jjgash6do",
    "google-site-verification=Jv2Ewm74qlxbBXG74YEHkvDVAYLi9p5J4VufHwBE_GM",
    "google-site-verification=T-D1W6lMJyTPaB5f4ZIma3eZcuR0RtlmzR3uY0JJzKU",
  ]
}

resource "aws_route53_record" "baj_mx" {
  zone_id = aws_route53_zone.baj.zone_id
  name = ""
  type = "MX"
  ttl = 3600
  records = [
    "1 ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "5 ALT2.ASPMX.L.GOOGLE.COM.",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM.",
    "15 oye2maapybs5vpzmnvahlapqcjkuuz4f3ii57eiw6lksir6iubla.mx-verification.google.com.",
  ]
}

resource "aws_route53_record" "baj_sendgrid_CNAME" {
  zone_id = aws_route53_zone.baj.zone_id
  name = "em9253"
  type = "CNAME"
  ttl = 3600
  records = ["u8791193.wl194.sendgrid.net"]
}

resource "aws_route53_record" "baj_sendgrid_s1domainkey_CNAME" {
  zone_id = aws_route53_zone.baj.zone_id
  name = "s1._domainkey"
  type = "CNAME"
  ttl = 3600
  records = ["s1.domainkey.u8791193.wl194.sendgrid.net"]
}

resource "aws_route53_record" "baj_sendgrid_s2domainkey_CNAME" {
  zone_id = aws_route53_zone.baj.zone_id
  name = "s2._domainkey"
  type = "CNAME"
  ttl = 3600
  records = ["s2.domainkey.u8791193.wl194.sendgrid.net"]
}

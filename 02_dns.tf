variable "domain" {}

resource "digitalocean_domain" "domphish" {
  name = "${var.domain}"
}

# Add an A record to the domain for www.domphish.com.
resource "digitalocean_record" "mail" {
  domain = digitalocean_domain.domphish.id
  type   = "A"
  name   = "mail"
  ttl = 30
  value  = digitalocean_droplet.mail-srv.ipv4_address
}

# Add a MX record for the domphish.com domain itself.
resource "digitalocean_record" "mx" {
  domain   = digitalocean_domain.domphish.id
  type     = "MX"
  name     = "@"
  priority = 10
  ttl    = "14400"
  value    = "mail.${var.domain}"
}

# Add a TXT record for SPF record to mg.domphish.com domain
resource "digitalocean_record" "spf" {
  domain = digitalocean_domain.domphish.id
  type   = "TXT"
  name   = "mg"
	priority = 0
	value = "v=spf1 include:mailgun.org ~all"
}

# SPF
resource "digitalocean_record" "self-spf" {
  domain = digitalocean_domain.domphish.id
  type   = "TXT"
  name   = "@"
  ttl    = "14400"
  value  = "v=spf1 mx ~all"
}

# Add a TXT record for dkim record to mg.domphish.com domain
resource "digitalocean_record" "dkim" {
  domain = digitalocean_domain.domphish.id
  type   = "TXT"
  name   = "pic._domainkey.mg.${var.domain}."
	priority = 0
	value = "" #value from mailgun records
}

# DMARC
resource "digitalocean_record" "dmarc" {
  domain = digitalocean_domain.domphish.id
  type   = "TXT"
  name   = "_dmarc"
  ttl    = "14400"
  value  = "v=DMARC1; p=reject; rua=mailto:dmarc-reports@${digitalocean_domain.domphish.id}"
}

# Add a MX record for the mg.domphish.com domain to MailGun.
resource "digitalocean_record" "mx1" {
  domain   = digitalocean_domain.domphish.id
  type     = "MX"
  name     = "mg"
  priority = 10
  value    = "mxa.mailgun.org."
}

# Add a MX record for the mg.domphish.com domain to MailGun.
resource "digitalocean_record" "mx2" {
  domain   = digitalocean_domain.domphish.id
  type     = "MX"
  name     = "mg"
  priority = 10
  value    = "mxb.mailgun.org."
}

# Add a CNAME record for the domain email.mg.domphish.com subdomain
resource "digitalocean_record" "cname" {
	domain = digitalocean_domain.domphish.id
	type = "CNAME"
	name = "email.mg"
	value = "mailgun.org."
}

# SMTP
resource "digitalocean_record" "smtp" {
  domain = digitalocean_domain.domphish.id
  type   = "CNAME"
  name   = "smtp"
  ttl    = "14400"
  value  = "mail.${digitalocean_domain.domphish.id}."
}

# POP
resource "digitalocean_record" "pop" {
  domain = digitalocean_domain.domphish.id
  type   = "CNAME"
  name   = "pop"
  ttl    = "14400"
  value  = "mail.${digitalocean_domain.domphish.id}."
}

# IMAP
resource "digitalocean_record" "imap" {
  domain = digitalocean_domain.domphish.id
  type   = "CNAME"
  name   = "imap"
  ttl    = "14400"
  value  = "mail.${digitalocean_domain.domphish.id}."
}


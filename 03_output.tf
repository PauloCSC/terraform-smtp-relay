# Output the FQDN for the www A record.
output "www_fqdn" {
  value = digitalocean_record.mail.fqdn # => www.rcorex.com
}

# Output the FQDN for the MX record.
output "mx_fqdn" {
  value = digitalocean_record.mx.fqdn # => rcorex.com
}

output "smtp" {
  value = digitalocean_record.smtp.fqdn
}
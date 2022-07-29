variable "hostname" {}

resource "digitalocean_droplet" "mail-srv" {
  image  = "ubuntu-20-04-x64"
  name   = "${var.hostname}"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  user_data = file("${path.module}/userdata.yaml")
  ssh_keys = [
    data.digitalocean_ssh_key.key.fingerprint
  ]
}

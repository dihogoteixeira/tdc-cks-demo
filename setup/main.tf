module "master" {
    source                  = "./gcp-instance"

    name                    = "tdc-master"
    image                   = "ubuntu-os-cloud/ubuntu-1804-lts"
    machine_type            = "e2-medium"
    metadata_startup_script = "./scripts/install_master.sh"

    ssh_keys = [
        {
            publickey = "ssh-rsa yourkeyabc username@PC"
            user      = "username"
        } 
    ]
}

module "worker" {
    source                  = "./gcp-instance"

    name                    = "tdc-worker"
    image                   = "ubuntu-os-cloud/ubuntu-1804-lts"
    machine_type            = "e2-medium"
    metadata_startup_script = "./scripts/install_worker.sh"

    ssh_keys = [
        {
            publickey = "ssh-rsa yourkeyabc username@PC"
            user      = "username"
        } 
    ]
}

# Firewall
data "google_compute_network" "tdc" {
  name = "default"
}

resource "google_compute_firewall" "nodeports" {
  name          = "nodeports"
  network       = data.google_compute_network.tdc.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["tdc"]
  allow {
    protocol = "tcp"
    ports    = ["22","30000-40000"]
  }
}
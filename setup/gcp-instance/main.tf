resource "google_compute_instance" "this" {
  count        = var.amount
  
  name         = format("%s-%d", var.name, count.index)
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["tdc"]

  metadata = {
    ssh-keys = join("\n", [for key in var.ssh_keys : "${key.user}:${key.publickey}"])
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network    = var.network
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = file(var.metadata_startup_script)

}

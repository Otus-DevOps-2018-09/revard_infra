resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "null_resource" "app_provisioner" {
  count = "${var.provision_var}"

  provisioner "file" {
    source      = "${var.files_puma_service}"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${var.files_deploy_sh}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
    host        = "${google_compute_instance.app.network_interface.0.access_config.0.assigned_nat_ip}"
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

# Provider google

provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

# Res instance

resource "google_compute_instance" "app" {
  #  name         = "reddit-app"
  name         = "reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  count        = "2"

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {
      #      nat_ip = "${element(google_compute_address.*.self_link, count.index)}"  #      nat_ip = "${google_compute_address.default.address}"  #    nat_ip = "${lookup(var.instance_ips, count.index)}"  # nat_ip = "${google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip}"
    }
  }

  #metadata {
  #  ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}"
  #}

  tags = ["reddit-app"]
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }
}

resource "google_compute_project_metadata" "ssh_keys" {
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}"
  }
}

# Res firewall

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}

#variable "instance_ips" {
#  default = {
#    "0" = "35.241.163.65"
#    "1" = "35.241.163.66"
#  }
#}


#output "externalip" {
# value = "${google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip}"
#}


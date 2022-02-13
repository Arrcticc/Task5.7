terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.70.0"
    }
  }
}
data "yandex_compute_image" "my_image" {
  family = var.image
} 
resource "yandex_compute_instance" "default" {
  name        = "terraform-${var.image}"
  platform_id = "standard-v1"
  zone        = var.zone_ins

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
    }
  }

  network_interface {
    subnet_id = var.subnet
    nat       = true
  }

   metadata = {
     ssh-keys = "ubuntu:${file("my.pem")}"
   }
}

output "instance_ip" {
  value = yandex_compute_instance.default.network_interface.0.ip_address
}
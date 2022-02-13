terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.70.0"
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "BLA"
    region     = "ru-central1-a"
    key        = "BLA"
    access_key = "BLA"
    secret_key = "BLA"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
provider "yandex" {
  token     = "BLA"
  cloud_id  = "cloud-arrcticcya"
  folder_id = "BLA"
#  zone      = "ru-central1-a"
}
resource "yandex_vpc_network" "network" {
  name = "network"
}
resource "yandex_vpc_subnet" "first" {
  name           = "first"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.100.0/24"]
}

resource "yandex_vpc_subnet" "second" {
  name           = "second"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.200.0/24"]
}

module "one" {
  source = "./modules" 
  image = "lamp"
  subnet = yandex_vpc_subnet.first.id
  zone_ins = "ru-central1-a"
}

module "two" {
  source = "./modules" 
  image = "lemp"
  subnet = yandex_vpc_subnet.first.id
  zone_ins = "ru-central1-a"
}

resource "yandex_lb_target_group" "foo" {
  name      = "my-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.first.id
    address   = module.one.internal_ip_address_vm
  }

  target {
    subnet_id = yandex_vpc_subnet.first.id
    address   = module.two.internal_ip_address_vm
  }
}

resource "yandex_lb_network_load_balancer" "task57" {
  name = "my-network-load-balancer"
  listener {
    name = "listener1"
    port = 80    
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.foo.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
#        path = "/ping"
      }
    }
  }
}

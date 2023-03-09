terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.86.0"
    }
  }
}

variable "token" {
  type = string
  description = "Token"
}

provider "yandex" {
  token = var.token
  cloud_id = "b1gprcjj64afi0vdqjdv"
  folder_id = "b1gpjrnl8ltbu6on2c0t"
  zone = "ru-central1-a"
}

variable "name" {
  type = string
  description = "Instance name"
}

variable "cores" {
  type = string
  default = 4
  description = "CPU cores"
}

variable "memory" {
  type = string
  default = 4
  description = "RAM memory"
}

variable "image_id" {
  type = string
  default = "fd8emvfmfoaordspe1jr"
  description = "ID image from cloud"
}

resource "yandex_compute_instance" "instance" {
  name        = var.name
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet.id}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network" {
  name = "generated_network"
}

resource "yandex_vpc_subnet" "subnet" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network.id}"
  v4_cidr_blocks = ["84.201.175.62/24"]
}
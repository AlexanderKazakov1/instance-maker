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
  description = "CPU cores"
}

variable "memory" {
  type = string
  description = "RAM memory"
}

variable "image_id" {
  type = string
  default = "fd8emvfmfoaordspe1jr"
  description = "ID image from cloud"
}

resource "yandex_compute_instance" "instance" {
  name = var.name
  allow_stopping_for_update = true
  platform_id = "standard-v3"
  zone = "ru-central1-a"

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
    subnet_id = yandex_vpc_subnet.subnet.id
    nat = true
  }

  metadata = {
    ssh-keys = "ssh-keys: user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3iebUVt+oJ5Zt020eUhz0MOPZidX6GxlfikIeWZX3N1KAx3XfbVZ3UiL5urXyiXuNJBo5XpVnph5J9Wo1skglQ9Fmc1HQD/Ey2Ug7MIYCZmibAyIQ5KY5dUysuo/SL8P12PhpUzkZeCZyL/BJHCyz7P1tcP/URMDV6cbpUdB7bZV62jGsuj1SCty2GqFYHRK3blmi8TbuR2n3ddrbF2MTlQlj8bNDff4NtUCwKuX8tw/ROL98T3QZFqqgvFAn8Yw0UPNVAgkXJ/YxXS1fk353Z5bSu2BNDUeNBbbXdiiJYCKmgFx+pTtYkNsbihg1CbS2fsuV2uwZCkuHF129Mb8c3cnqgcjZuhrEolqaGJELAWm08gfjtAWfST3+zh18jtnQGvEKLXIQW8eLcll8d5mMgtPIRHdHzlQD5b1QeEManAfM4gs6A2nooHZ1gsPIPJQTVfDgXj8UxCwdOyGWfLFz+hwsS5rqzLd/XyGONV2T6Ft/JvZHvpSF6aMZuZ6MIW0= user@ubuntu-20-4-14"
    user-data = file("./meta.yml")
  }
}

resource "yandex_vpc_network" "network" {
  name = "generated_network"
}

resource "yandex_vpc_subnet" "subnet" {
  name = "generated_subnet"
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.15.0/24"]
}
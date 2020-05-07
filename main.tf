provider "profitbricks" {
}

resource "profitbricks_datacenter" "vdc" {
  name = "terraform-dc"
  location = "de/fra"
}

resource "profitbricks_lan" "webserver_lan" {
  datacenter_id = profitbricks_datacenter.vdc.id
  public = true
  name = "public"
}

resource "profitbricks_ipblock" "webserver_ip" {
  location = profitbricks_datacenter.vdc.location
  size = var.vm_count
}

resource "profitbricks_server" "webserver" {
  count             = var.vm_count
  name              = "webserver"
  datacenter_id     = profitbricks_datacenter.vdc.id
  cores             = 1
  ram               = 1024
  availability_zone = "AUTO"

  volume {
    name           = "system"
    size           = 15
    disk_type      = "HDD"
  }
  image_name     = var.os_image
  image_password = "StrengGeheim"
  ssh_key_path   = var.public_key_path

  nic {
    lan             = profitbricks_lan.webserver_lan.id
    dhcp            = true
    ip = profitbricks_ipblock.webserver_ip.ips[count.index]
    firewall {
      protocol = "TCP"
      name = "SSH"
      port_range_start = 22
      port_range_end = 22
    }
  }
  provisioner "remote-exec" {
    inline = [
      "while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do sleep 1; done",
      "apt-get update && apt-get -y install nginx"
    ]
    connection {
      type = "ssh"
      private_key = file(var.private_key_path)
      user = "root"
      timeout = "4m"
      host = self.primary_ip
    }
  }
}

output "server_info" {
  value = profitbricks_server.webserver
}

output "ips" {
  value = join(" ", profitbricks_ipblock.webserver_ip.ips)
}

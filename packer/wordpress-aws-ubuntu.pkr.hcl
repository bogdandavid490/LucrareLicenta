packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-wordpress-aws"
  instance_type = "t3.micro"
  region        = "eu-north-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username            = "ubuntu"
  temporary_key_pair_type = "ed25519"
}

build {
  name = "packer-wordpress-emagazin-aws"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    scripts = [
      # base install
      "scripts/ami_config_script.sh"
    ]

  }
  provisioner "file" {
    source      = "./config/nginx.conf"
    destination = "~/nginx.conf"
  }
  provisioner "file" {
    source      = "./config/wordpress_nginx.conf"
    destination = "~/wordpress_nginx.conf"
  }
  provisioner "file" {
    source      = "config/wordpress_phpfpm.conf"
    destination = "~/phppool.conf"
  }
  provisioner "shell" {
    # copying files in two steps because of packer/sudo limitations
    inline = [
      "sudo mv ~/nginx.conf /etc/nginx/nginx.conf",
      "sudo mv ~/wordpress_nginx.conf /etc/nginx/conf.d/emagazin.conf",
      "sudo mv ~/phppool.conf /etc/php/8.3/fpm/pool.d/emagazin.conf",
    ]
  }
  provisioner "shell" {
    scripts = [
      # final WordPress application setup
      "scripts/wordpress_site_setup.sh"
    ]
  }

}

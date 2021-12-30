data "amazon-ami" "yusuf" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}

source "amazon-ebs" "yusuf" {
  ssh_username  = "ubuntu"
  ami_name      = "yusuf-${uuidv4()}"
  source_ami    = data.amazon-ami.yusuf.id
  instance_type = "t3.micro"
}

build {
  sources = ["source.amazon-ebs.yusuf"]
  provisioner "shell" {
    execute_command = "sudo -S env {{ .Vars }} {{ .Path }}"
    inline = [
      "apt-get update",
      "apt-get install -y nginx php-fpm",
    ]
  }
}
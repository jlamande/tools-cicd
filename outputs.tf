output "image_id" {
  value = data.aws_ami.ubuntu.id
}

output "ssh_key_fingerprint" {
  value = tls_private_key.default.public_key_fingerprint_md5
}

locals {
  access_doc = templatefile("${path.module}/files/NOTES.md.tftpl", {
    tools_dns = aws_instance.tools.public_dns
    tools_ip = aws_instance.tools.public_ip
  })
}

output "access_doc" {
  value = <<EOT
SSH Access :
ssh -i ./id_rsa ubuntu@${aws_instance.tools.public_dns}

Jenkins Url :
http://${aws_instance.tools.public_dns}:8080

EOT
}

resource "local_file" "notes" {
  content  = local.access_doc
  filename = "${path.module}/NOTES.md"
}

output "pub_sub" {
  value = data.aws_subnets.public_subnets.ids
}

output "deploy_inst_ip" {
  value=data.aws_instance.deploy_inst.public_ip
}
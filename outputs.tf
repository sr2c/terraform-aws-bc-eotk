
output "instances" {
  description = <<-EOT
  An object mapping the availability zone in use to the instance ID for the created EC2 instance running EOTK in that
  availability zone.
  EOT
  value = {
    for i in range(var.instance_count) : data.aws_availability_zones.available.names[i] => module.instance[i].id
  }
}

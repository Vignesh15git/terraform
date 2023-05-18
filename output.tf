# Define Output Values

# Attribute Reference
output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.PUB-SER.*.public_ip
}


# Attribute Reference - Create Public DNS URL
output "ec2_instance_tags" {
  description = "Public DNS URL of an EC2 Instance"
  value       = aws_instance.PVT-SER.*.tags
}
# Attribute Reference
output "VPC-CIDR-value" {
  description = "CIDR-Value"
  value       = aws_vpc.VPC-01.*.cidr_block
}
# Attribute Reference
output "VPC-1A-CIDR-value" {
  description = "CIDR-Value"
  value       = aws_vpc.VPC-01A.*.cidr_block
}
# Attribute Reference
output "public_subnet-CIDR-value" {
  description = "CIDR-Value"
  value       = aws_subnet.PUB-SUB.*.id
}
# Attribute Reference
output "private_subnet-CIDR-value" {
  description = "CIDR-Value"
  value       = aws_subnet.PVT-SUB.*.id
}
# Attribute Reference
output "VPC-ID" {
  description = "VPC-ID"
  value       = aws_vpc.VPC-01.id
}




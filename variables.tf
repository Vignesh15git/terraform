# Input Variables
variable "aws_regions_mumbai" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "ap-south-1"
}
variable "aws_vpc" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "aws_vpc.VPC-01.id"
}

variable "aws_regions_porur" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "us-east-1"
 
}
variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-079b5e5b3971bd10d" # Amazon2 Linux AMI ID
}

variable "ec2_ami_id2" {
  description = "AMI ID"
  type        = string
  default     = "ami-06604eb73be76c003" # Amazon2 Linux AMI ID
}
variable "ec2_instance_count" {
  description = "EC2 Instance Count"
  type        = number
  default       = 4
}

variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 8300
      external = 8300
      protocol = "tcp"
    }
  ]
}
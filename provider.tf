provider "aws" {
  region  = var.aws_regions_mumbai
  profile = "default"
}
# Configure the AWS Provider
provider "aws" {
  region = var.aws_region_porur
  alias = "viki"
}
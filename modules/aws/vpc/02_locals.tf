# locals.tf

locals {
  azs        = slice(data.aws_availability_zones.available.names, 0, 3)
  public_azs = slice(local.azs, 0, 2)
}

data "aws_availability_zones" "available" {
  state = "available"
}

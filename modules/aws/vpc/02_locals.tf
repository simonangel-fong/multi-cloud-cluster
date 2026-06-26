# locals.tf

locals {
  azs        = slice(data.aws_availability_zones.available.names, 0, 3)
  public_azs = local.azs
}

data "aws_availability_zones" "available" {
  state = "available"
}

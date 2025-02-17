module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "adservice_version"
  hash_key = "adservice_version"
  
  attributes = [
    {
      name = "adservice_version"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
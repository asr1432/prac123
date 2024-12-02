terraform {
  backend "s3" {
    bucket = "asr1432"
    region = "ap-northeast-3"
    key = "day-0/terraform.tfstate"
    encrypt = true

    
  }
}
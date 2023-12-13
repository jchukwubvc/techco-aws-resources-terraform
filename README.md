# techco-aws-resources-terraform
## 

### Author: Johnpaul Chukwu
### Email: j.chukwu493@mybvc.ca

## DESCRIPTION

This Terraform configuration essentially sets up a basic infrastructure on AWS with a public subnet,
allowing SSH, HTTP, and custom traffic on port 8080. The EC2 instance is configured to run a
basic user data script installing updates, Apache HTTP Server, and Docker upon launch.


## Prerequisite
* Terraform
* Valid AWS Console Credentials (aws_access_key and aws_secret_key)

```bash
brew install terraform.
```

## Before deployment
In the root directory, create a `terraform.tfvars` file to specify the variables needed to run the script.

In the created `terraform.tfvars` file specify the content like so:
```
aws_access_key = "your_access_key_id"
aws_secret_key = "your_secret_access_key"
aws_region     = "your_aws_region"
```

Still in the root directory execute the following commands:

1. `terraform init` in terminal.
2. `terraform plan` in terminal and observe for desired changes.
3. `terraform apply` in terminal.
4. `yes` to execute configuration.
5. View desired changes on AWS management console.


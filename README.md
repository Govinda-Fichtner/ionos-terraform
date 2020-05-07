# Terraform Example for Ionos Cloud
This is respository contains some examples for how to use the Terraform provider of the Ionos cloud. It is compatible for Terraform version >0.12.

## Usage
This terraform script expect to pick up the Ionos Cloud user credentials via two environment variables.

- PROFITBRICKS_USERNAME
- PROFITBRICKS_PASSWORD

The configuration happens in the `terraform.tfvars` file. 
Configure the path to your private and public ssh key files there. 
Also how many VMs you want to have created. 

Afterwards execute the script with:

```
$ terraform init
$ terraform plan
$ terraform apply
```

## Higher parallism
By default Terraform assumes a parallism of 10. If you want more parallism you can configure it when executing Terraform:

```
terraform apply -parallelism=20 -auto-approve
```



## Commands Scratch Book
Make a HTTP request against all webservers to check if nginx was installed correctly.
```
for ip in $(terraform output ips); do http -p=h $ip; done
```
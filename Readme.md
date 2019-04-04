# Assingments
1. Terraform script to create a N node cluster with nginx install and a load Balancer attached.Update the aws secret key and aws access key inside variables-sercret and keyname in variables  file.

```
$ cd terraform
$ terraform init
$ terraform apply
```
2. check for running process.
 edit the config server_config with server names to check ,timeout for how much time to check,process_name as which process to check
 ```
 $ ./service_check.py 
 OR
 $ ./service_check.py --file config_file
 ```

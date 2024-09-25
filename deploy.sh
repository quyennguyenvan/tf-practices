terraform init -backend-config=dev.conf
terraform plan -var-file=envs/${current_tfwsp}.tfvars
terraform apply -var-file=envs/${current_tfwsp}.tfvars
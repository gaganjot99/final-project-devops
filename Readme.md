---Create the following three s3 buckets:
dev-gaganjot-bucket
prod-gaganjot-bucket
gaganjot-images

---upload 4 images to gaganjot-images buckets and name them the following:
img1.jpg
img2.jpg
img3.jpg

cd Terraform/Env/networks
terraform init
terraform plan
terraform apply --auto-approve

cd Terraform/Env/webservers
ssh-keygen -t rsa -f group3 
terraform init
terraform plan
terraform apply --auto-approve

---for Ansible run

cd Ansible/
ssh-keygen -t rsa -f group3 

--update the ip address the in the hosts.yml to public ip address of public-vm-2 and public-vm-3
--run the following command:
`ansible-playbook -i hosts.yml playbook.yml`




#!/bin/bash

echo copy credentials.tfvars file
cp ~/deployments/kubespray/contrib/terraform/aws/credentials.tfvars.example ~/deployments/kubespray/contrib/terraform/aws/credentials.tfvars

echo -n AWS Access Key ID: 
read -s AWS_ACCESS_KEY_ID
echo

echo -n AWS Secret Key: 
read -s AWS_SECRET_ACCESS_KEY
echo

echo -n AWS region: 
read -s AWS_DEFAULT_REGION
echo

echo update credentials.tfvars settings
sed -i "s/AWS_ACCESS_KEY_ID.*/AWS_ACCESS_KEY_ID = \"$AWS_ACCESS_KEY_ID\"/g" ~/deployments/kubespray/contrib/terraform/aws/credentials.tfvars
sed -i --expression "s@AWS_SECRET_ACCESS_KEY.*@AWS_SECRET_ACCESS_KEY = \"$AWS_SECRET_ACCESS_KEY\"@g" ~/deployments/kubespray/contrib/terraform/aws/credentials.tfvars
sed -i "s/AWS_SSH_KEY_NAME.*/AWS_SSH_KEY_NAME = \"deployment-key\"/g" ~/deployments/kubespray/contrib/terraform/aws/credentials.tfvars
sed -i "s/AWS_DEFAULT_REGION.*/AWS_DEFAULT_REGION = \"$AWS_DEFAULT_REGION\"/g" ~/deployments/kubespray/contrib/terraform/aws/credentials.tfvars

echo "create aws config files for ssh deployment"
mkdir -p ~/.aws
cat <<EOT > ~/.aws/config
[default]
region=us-east-1
output=json
EOT
cat <<EOT > ~/.aws/credentials
[default]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
EOT

echo "ensure local time Zone is set to proper value - Europe/Warsaw"
sudo timedatectl set-timezone 'Europe/Warsaw'

echo "deploy ssh to aws"
aws ec2 create-key-pair --key-name deployment-key > ~/.ssh/id_rsa_aws

echo "done"

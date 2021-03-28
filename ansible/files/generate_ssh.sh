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

echo "Do you want to deploy ssh key to AWS? true/yes to accept, any value to skip"
read DEPLOY_KEY

if [[ $DEPLOY_KEY = 'true' ]] || [[ $DEPLOY_KEY = 'yes' ]]
then
  echo "ensuring that local time Zone is set to proper value - Europe/Warsaw"
  sudo timedatectl set-timezone 'Europe/Warsaw'

  echo "type name for new ssh key pair:"
  read SSH_NAME

  echo "generating new ssh key pair"
  ssh-keygen -t rsa -N "" -C "$SSH_NAME" -f ~/.ssh/id_rsa.pem

  echo "deploy ssh to aws"
   aws ec2 import-key-pair --key-name "$SSH_NAME" --public-key-material fileb://~/.ssh/id_rsa.pem.pub

  echo "set permission 600 to ssh key"
  chmod 600 .ssh/id_rsa.pem

  echo "add key to ssh-agent"
  ssh-add ~/.ssh/id_rsa
  echo "ssh-add ~/.ssh/id_rsa" >> ~/.bashrc

  echo "credentials.tfvars settings updated with new key pair name"
  sed -i "s/AWS_SSH_KEY_NAME.*/AWS_SSH_KEY_NAME = \"$SSH_NAME\"/g" ~/deployments/kubespray/contrib/terraform/aws/credentials.tfvars
else
  echo "Key deploy skipped"
fi

echo "update credentials.tfvars settings"
sed -i "s/AWS_ACCESS_KEY_ID.*/AWS_ACCESS_KEY_ID = \"$AWS_ACCESS_KEY_ID\"/g" ~/deployments/kubespray/contrib/terraform/aws/credentials.tfvars
sed -i --expression "s@AWS_SECRET_ACCESS_KEY.*@AWS_SECRET_ACCESS_KEY = \"$AWS_SECRET_ACCESS_KEY\"@g" ~/deployments/kubespray/contrib/terraform/aws/credentials.tfvars
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

echo "done"

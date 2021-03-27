#!/bin/bash

echo "AWS Cluster Name:" 
read AWS_CLUSTER_NAME
echo

echo "AWS Mashines Size (t2.nano/t2.micro/t2.small/t2.medium/t2.large/t2.xlarge/t2.2xlarge):"
read AWS_MASHINES_SIZE
echo

echo "update terraform.tfvars settings"
if [[ ! -z $AWS_CLUSTER_NAME ]]
then
  sed -i "s/aws_cluster_name.*/aws_cluster_name = \"$AWS_CLUSTER_NAME\"/g" ~/deployments/kubespray/contrib/terraform/aws/terraform.tfvars
  echo "cluster name updated"
else
  echo "cluster name update skipped"
fi
if [[ $AWS_MASHINES_SIZE = "t2.nano" ]] || [[ $AWS_MASHINES_SIZE = "t2.micro" ]] || [[ $AWS_MASHINES_SIZE = "t2.small" ]] || [[ $AWS_MASHINES_SIZE = "t2.medium" ]] || [[ $AWS_MASHINES_SIZE = "t2.large" ]] || [[ $AWS_MASHINES_SIZE = "t2.xlarge" ]] || [[ $AWS_MASHINES_SIZE = "t2.2xlarge" ]]
then
  sed -i "s/aws_bastion_size.*/aws_bastion_size = \"$AWS_MASHINES_SIZE\"/g" ~/deployments/kubespray/contrib/terraform/aws/terraform.tfvars
  sed -i "s/aws_kube_master_size.*/aws_kube_master_size = \"$AWS_MASHINES_SIZE\"/g" ~/deployments/kubespray/contrib/terraform/aws/terraform.tfvars
  sed -i "s/aws_etcd_size.*/aws_etcd_size = \"$AWS_MASHINES_SIZE\"/g" ~/deployments/kubespray/contrib/terraform/aws/terraform.tfvars
  sed -i "s/aws_kube_worker_size.*/aws_kube_worker_size = \"$AWS_MASHINES_SIZE\"/g" ~/deployments/kubespray/contrib/terraform/aws/terraform.tfvars
  echo "machines size updated"
else
  echo "machines size update skipped"
fi

echo "done

Now you are ready to run ansible deployment. Please go to ~/deployments/kubespray and run the command:

ansible-playbook -i ./inventory/hosts ./cluster.yml -e ansible_user=core -b --become-user=root --flush-cache"

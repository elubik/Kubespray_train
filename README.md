## Exercise tasks:
1. Build a local stack consisting of several virtual machines based on Ubuntu 18.04 or Ubuntu 20.04. Stack requirements: 
    1. Stack and its IP address allocation must be described as code. 
    1. Choose any virtualization software that's supporting Linux operating system. 
    1. Stack should fulfil security standard of your choice. 
    1. Virtual machine customization towards this standard compliance should be described as code. 
1. Then on top of this stack build a local Kubernetes cluster. Kubernetes cluster requirements: 
    1. Installation of the Kubernetes must be described as code. 
    1. Cluster control plane must be highly available. 
    1. Cluster must contain at least one worker node. 
1. End goal is a git repository (hosting provider of your choice, GitHub, GitLab, Bitbucket or any other). 
    1. Repository must contain a full documentation how to start the stack in README.md file. 
    1. Starting the stack should not require a manual steps. 

## Prerequisites:
All you need is to have:
* **Vagrant**
* virtualization provider (**VirtualBox**) to run Vagrant virtual mashine for all the deployment things
* **AWS account** (credentials)

## Solution steps:
1. Create dedicated folder
    ```
    mkdir Kubespray_train
    cd Kubespray_train
    ```
1. Clone this repo to your mashine. 
    ```
    git clone git@github.com:elubik/Kubespray_train.git
    ```
1. Run and ssh into Vagrant
    ```
    vagrant up --provision
    vagrant ssh
    ```
1. Now we are inside our deployment environment where we already have installed some tools like **awscli, terraformm, ansible, python3**. Now let run script to setup **AWS credentials** and deploy **ssh key** to our AWS. You'll need to provide: _AWS_ACCESS_KEY_ID_, _AWS_SECRET_ACCESS_KEY_, _AWS_DEFAULT_REGION_
    ```
    cd ~/deployments/deploy_aws/
    ./generate_ssh.sh
    ```
1. (optionally) Run another script to customize our cluster name and machines size. This can be manually done by editing _~/deployments/kubespray/contrib/terraform/aws/terraform.tfvars_. You'll need to provide: _AWS Cluster Name_ (anything fancy) and _AWS Mashines Size_ (like t2.* or t3.* at least medium)
    ```
    cd ~/deployments/deploy_aws/
    ./aws_infrastructure_customize.sh
    ```

1. Finally switch to location for our kubespray deployment.
    ```
    cd ~/deployments/kubespray/contrib/terraform/aws/
    ```
1. Run terraform to deploy virtual machines. It can take few minutes.
    ```
    terraform init
    terraform plan -out aws_plan -var-file=credentials.tfvars
    terraform apply "aws_plan"
    ```
1. Once this is deployed we are ready to go with cluster deploy. This can take like 20 minutes.
    ```
    cd ~/deployments/kubespray
    ansible-playbook -i inventory/hosts cluster.yml -e ansible_user=ubuntu -b --become-user=root --flush-cache
    ```
1. Finally after you obtain **~/.kube/config** from one of your _masters (control planes)_ to your machine and update **server** IP parameter part inside it with **apiserver_loadbalancer_domain_name** to have like below, you will be able to play with your kubernetes cluster with _kubectl_.
    ```
    server: https://kubernetes-elb-train-cluster-1316130565.us-east-1.elb.amazonaws.com:6443
    ```
    ```
    (env) vagrant@vagrant:~$ kubectl get nodes
    NAME                             STATUS   ROLES                  AGE    VERSION
    ip-10-250-196-12.ec2.internal    Ready    control-plane,master   124m   v1.20.5
    ip-10-250-198-2.ec2.internal     Ready    <none>                 122m   v1.20.5
    ip-10-250-199-114.ec2.internal   Ready    control-plane,master   123m   v1.20.5
    ip-10-250-200-132.ec2.internal   Ready    <none>                 122m   v1.20.5
    ip-10-250-214-135.ec2.internal   Ready    <none>                 122m   v1.20.5
    ip-10-250-215-111.ec2.internal   Ready    <none>                 122m   v1.20.5
    ip-10-250-222-135.ec2.internal   Ready    control-plane,master   123m   v1.20.5
    ```
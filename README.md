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
    ./generate_ssh.sh
    ```
1. (optionally) Run another script to customize our cluster name and machines size. This can be manually done by editing _~/deployments/kubespray/contrib/terraform/aws/terraform.tfvars_. You'll need to provide: _AWS Cluster Name_ (anything fancy) and _AWS Mashines Size_ (t2.nano/t2.micro/t2.small/t2.medium/t2.large/t2.xlarge/t2.2xlarge)

1. Finally switch to location for our deployment.
    ```
    cd ~/deployments/kubespray/contrib/terraform/aws/
    ```
1. Run terraform to deploy virtual machines. It can take few minutes.
    ```
    terraform init
    terraform plan -out cluster_deployment_plan -var-file=credentials.tfvars
    terraform apply “mysuperplan”
    ```

TBD: 
* Deploy cluster
* Configure access
* run test deployments
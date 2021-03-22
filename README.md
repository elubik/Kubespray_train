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

**************
Notejam: Flask: Implementation on AWS EKS
Author: Nishanthi Baskar
**************

==========================
Implementation on AWS EKS
==========================
Docker: Dockerizing flask application

$ cd YOUR_PROJECT_DIR/flask/
# Dockerfile is written to pull amazonlinux:latest image and install required packages on top of it to execute flask application.

Docker build and push the image to AWS ECR.

 $ aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 514924332194.dkr.ecr.eu-north-1.amazonaws.com  
 $ docker build -t nordcloud .   (this will build the image and store it in local repo)
 $ docker tag nordcloud:latest 514924332194.dkr.ecr.eu-north-1.amazonaws.com/nordcloud:nord_cloud
 $ docker push 514924332194.dkr.ecr.eu-north-1.amazonaws.com/nordcloud:nord_cloud
 
Creating EKS cluster and deploying ECR image:

To create AWS resources required IAM roles, EKS cluster and ECR I used terraform

Terraform execution:

$ cd YOUR_PROJECT_DIR/flask/terraform_files
$ terraform init
$ terraform validate
$ terraform plan
$ terraform apply

Deploy the application using kubectl.

$ aws eks update-kubeconfig --name nord-cloud-cluster --region eu-north-1
$ kubectl apply -f deployment.yaml

Implementation with github actions:

This repository is activated with github actions by specifing .github/workflows/deploy.yml
instead of running each command to achive docker build, docker push, AWS resource creation and kubectl application deployment, all these tasked are group together as a pipeline to run each of the task sequentially using github actions on push to a master branch.
so whatever change happens inside the repo and on a successfull push to the master .github/workflows/deploy.yml gets executed and its flow is like below

1. Run terraform to create required AWS resources.
2. Docker build and push to AWS ECR repo.
3. Deploy the latest build docker image to AWS EKS cluster.

====================================
How to check your application url?
====================================

$ kubectl get services

look for your specific loadbalancer url and enter it in the browser.



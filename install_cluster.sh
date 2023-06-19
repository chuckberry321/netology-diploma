#!/bin/bash

set -e

cd terraform
terraform init && terraform apply -auto-approve

cd ../
rm -rf kubespray/inventory/mycluster
cp -rfp kubespray/inventory/sample kubespray/inventory/mycluster

cd terraform
export WORKSPACE=$(terraform workspace show)
export KUBECONFIG=~/.kube/$WORKSPACE/config
bash ./generate_inventory.sh > ../kubespray/inventory/mycluster/hosts.ini
terraform output -json ext_ip_address_master | jq -r '.[]' > ../master_addr
terraform output -json ext_ip_address_jenkins | jq -r '.[]' > ../jenkins_addr
export IP_MASTER=$(terraform output -json ext_ip_address_master | jq -r '.[]')

sleep 120

cd ../kubespray
ansible-playbook -i ../kubespray/inventory/mycluster/hosts.ini ../kubespray/cluster.yml --become --ssh-common-args='-o StrictHostKeyChecking=no'

cd ..
ansible-playbook -i master_addr k8s_conf.yml --user ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
ansible-playbook -i jenkins_addr jenkins.yml --user ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
rm -rf master_addr
rm -rf jenkins_addr

kubectl create namespace monitoring
kubectl create namespace test-app
helm install prometheus --namespace monitoring prometheus-community/kube-prometheus-stack
kubectl apply -f ./manifests/grafana-service-nodeport.yaml
helm install netology ./helm/diplomaapp -n test-app

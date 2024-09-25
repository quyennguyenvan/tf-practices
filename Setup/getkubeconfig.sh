#/bin/bash
function installkubectl() {
    echo "Starting install kubectl"
    platform='unknown'
    unamestr=$(uname)
    if [[ "$unamestr" == 'Linux' ]]; then
        echo "installing kubectl via curl"
        curl -LO https://dl.k8s.io/release/`curl -LS https://dl.k8s.io/release/stable.txt`/bin/linux/amd64/kubectl
        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin/kubectl
        kubectl version
    elif [[ "$unamestr" == 'Darwin' ]]; then
        echo "installing kubectl via brew"
        brew install kubectl 
        kubectl version
    else 
        echo "unsupported platform"
        echo "access this link to get support: https://kubernetes.io/vi/docs/tasks/tools/install-kubectl/"
        exit 1
    fi
}


echo "Starting update kubeconfig"
echo "Please enter your eks cluster name: (example default)"
read ekscluster
echo "Please enter your eks cluster region: (example ap-southeast-1)"
read region
echo "Please enter your AWS profile name: (example default)"
read profile
aws eks update-kubeconfig --name $ekscluster --region $region --profile $profile

echo "Verifying the eks cluster"
kubectl config current-context | grep $ekscluster  | wc -l
kubectl get namespace -A
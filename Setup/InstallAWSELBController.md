Ref: https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html

add  iam open id

eksctl utils associate-iam-oidc-provider --region=us-west-2 --cluster=qnveks --profile vti --approve

add service account

eksctl create iamserviceaccount \
  --cluster=qnveks \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::084375555299:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --profile vti \
  --region us-west-2

add helm

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=qnveks \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-west-2 \
  --set vpcId=vpc-0c2a1525239b24fd9

verify
kubectl get deployment -n kube-system aws-load-balancer-controller
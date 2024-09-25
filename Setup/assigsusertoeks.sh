#/bin/bash

#references document: https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html

AWS_REGION=us-west-2
AWS_PROFILE=vti
EKS_CLUSTER_NAME=qnveks
AWS_USER_ARN=arn:aws:iam::084375555299:user/quyennv_user
TYPE_ACCESS=cluster
POLICY_ARN=arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy

echo "setup user to access eks cluster"
aws eks associate-access-policy --cluster-name $EKS_CLUSTER_NAME --region $AWS_REGION  --profile $AWS_PROFILE --principal-arn $AWS_USER_ARN --access-scope type=$TYPE_ACCESS  --policy-arn $POLICY_ARN

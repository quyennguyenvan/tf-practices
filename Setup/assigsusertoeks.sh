#/bin/bash

#references document: https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html

AWS_REGION=us-west-2
AWS_PROFILE=vti
EKS_CLUSTER_NAME=qnveks
AWS_USER_ARN=arn:aws:iam::084375555299:user/quyennv_user
AWS_USERNAME=quyennv_user
TYPE_ACCESS=cluster
POLICY_ARN=arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy

#create the resources to access
echo "Create the access to eks cluster"
 aws eks create-access-entry --cluster-name $EKS_CLUSTER_NAME \
    --principal-arn $AWS_USER_ARN --type STANDARD --username $AWS_USERNAME --profile $AWS_PROFILE --region $AWS_REGION

echo "setup user to access eks cluster"
aws eks associate-access-policy --cluster-name $EKS_CLUSTER_NAME \
    --region $AWS_REGION  --profile $AWS_PROFILE --principal-arn $AWS_USER_ARN --access-scope type=$TYPE_ACCESS  --policy-arn $POLICY_ARN


# aws eks create-access-entry --cluster-name qnveks --principal-arn arn:aws:iam::084375555299:user/DE000037 --type STANDARD --user DE000037 --kubernetes-groups Viewers --profile vti --region us-west-2

# aws eks delete-access-entry --cluster-name qnveks --principal-arn arn:aws:iam::084375555299:user/DE000037 --profile vti --region us-west-2


# aws eks create-access-entry --cluster-name qnveks --principal-arn arn:aws:iam::084375555299:user/DE000037 --type STANDARD --username DE000037 --profile vti --region us-west-2

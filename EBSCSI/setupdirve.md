refences: https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html

odic=$(aws eks describe-cluster --name qnveks --query "cluster.identity.oidc.issuer" --profile vti --region us-west-2 --output text)

-> result: https://oidc.eks.us-west-2.amazonaws.com/id/CC8B20D65FE9E779F79B12001155B15C

aws iam create-role  
--role-name QUYENNV_AmazonEKS_EBS_CSI_DriverRole  
--assume-role-policy-document file://"aws-ebs-csi-driver-trust-policy.json"  
--profile vti

aws iam attach-role-policy  
--policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy  
--role-name QUYENNV_AmazonEKS_EBS_CSI_DriverRole  
--profile vti

aws iam create-policy  \
--policy-name QNV_KMS_Key_For_Encryption_On_EBS_Policy  \
--policy-document file://kms-key-for-encryption-on-ebs.json  \
--profile vti

aws iam attach-role-policy   
--policy-arn arn:aws:iam::084375555299:policy/QNV_KMS_Key_For_Encryption_On_EBS_Policy   
--role-name QUYENNV_AmazonEKS_EBS_CSI_DriverRole   
--profile vti


#Add the EBS CSI driver 
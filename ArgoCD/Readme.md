***Instruction install ARGO CD***


step 1: 
helm repo add argo-cd https://argoproj.github.io/argo-helm

step 2:

helm upgrade --install argocd argo-cd/argo-cd --version "${ARGOCD_CHART_VERSION}" \
  --namespace "argocd" --create-namespace \
  --values ~/environment/eks-workshop/modules/automation/gitops/argocd/values.yaml \
  --wait

***Get UI***

export ARGOCD_SERVER=$(kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname')
echo $ARGOCD_SERVER

***Get username and password***

default username: admin

password:
export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo $ARGOCD_PWD

***To login with ARGO CD with CLI***

argocd login $ARGOCD_SERVER --username admin --password $ARGOCD_PWD --insecure
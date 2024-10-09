step 1: helm repo add grafana https://grafana.github.io/helm-charts

step 2: helm repo update

step 3: kubectl create namespace logging

step 4: helm install loki grafana/loki-stack --namespace=logging --values=lokivalues.yml
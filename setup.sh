#!/bin/bash

ARGO_VERSION=7.6.12
helm repo add argo https://argoproj.github.io/argo-helm
helm install my-argo-cd argo/argo-cd --version $ARGO_VERSION -n argocd --create-namespace

# Setup repo & git credentials



# apply apps
# kubectl apply -f bootstrap.yaml
# kubectl apply -f apps.yaml

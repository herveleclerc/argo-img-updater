#!/bin/bash

kind create cluster

kubectx kind-kind

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

kubectl patch deployments.apps argocd-repo-server --patch-file vault-plugin/01-patch-argo.yaml
kubectl patch configmap argocd-cm -n argocd --patch-file vault-plugin/02-argo-cm.yaml

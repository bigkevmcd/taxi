#!/bin/sh
oc apply -f https://github.com/tektoncd/pipeline/releases/download/v0.8.0/release.yaml
oc apply -f https://github.com/tektoncd/triggers/releases/download/v0.1.0/release.yaml
oc new-project dev-environment
oc new-project stage-environment
oc new-project cicd-environment
oc apply -f ~/quayio-secret.yaml
oc apply -f ~/regcred.yaml
oc apply -f serviceaccount
oc adm policy add-scc-to-user privileged -z demo-sa
oc adm policy add-role-to-user edit -z demo-sa
kubectl create rolebinding demo-sa-admin-dev --clusterrole=admin --serviceaccount=cicd-environment:demo-sa --namespace=dev-environment
kubectl create rolebinding demo-sa-admin-stage --clusterrole=admin --serviceaccount=cicd-environment:demo-sa --namespace=stage-environment
oc apply -f templatesandbindings
oc apply -f interceptor
oc apply -f ci
oc apply -f cd
oc apply -f eventlisteners
echo "the following commands will need to be executed when the containers are all running"
echo "oc port-forward svc/el-cicd-event-listener 8080"
echo "tkn pipelinerun list"

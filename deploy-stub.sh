#!/bin/bash
if [ -z ${NAMESPACE} ]; then
	echo "NAMESPACE environment variable needs to be set"
	exit 1
fi

#if [ -z ${STUB_CONFIG} ]; then
	#echo "STUB_CONFIG environment variable needs to be set"
	#exit 1
#fi

kubectl create namespace $NAMESPACE
kubectl apply -f stub-deploy.yaml --namespace $NAMESPACE --validate=false
kubectl apply -f gitops.yaml --namespace $NAMESPACE

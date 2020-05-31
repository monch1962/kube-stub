# kube-stub

## To deploy
`$ kubectl delete namespace stub`

`$ NAMESPACE=stub ./deploy-stub.sh`

Deployment will take a few minutes. Keep trying
`$ kubectl get service --namespace stub`
until you get an EXTERNAL-IP returning

Then
`$ curl http://EXTERNAL-IP/api/health`
should return a response from Hoverfly

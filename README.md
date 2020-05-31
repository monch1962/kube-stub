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

## To configure
To PUT the stub configuration defined in `./stub-configs/stub-config.json` to the stub, use

`$ curl -t ./stub-configs/stub-config.json http://EXTERNAL-IP/api/v2/simulation`

Note that this will overwrite any existing stub configuration for the stub

The changed configuration can then be verified via
`$ curl http://EXTERNAL-IP/api/v2/simulation`

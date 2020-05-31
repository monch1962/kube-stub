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

## To configure a running stub (not recommended!)
To PUT the stub configuration defined in `./stub-configs/stub-config.json` to the stub, use

`$ curl -t ./stub-configs/stub-config.json http://EXTERNAL-IP/api/v2/simulation`

To PUT the stub configuration defined at a URL, use e.g.

`$ curl -t https://raw.githubusercontent.com/monch1962/kube-stub/master/stub-config.json http://EXTERNAL-IP/api/v2/simulation`

Note that this will overwrite any existing stub configuration for the stub

The changed configuration can then be verified via
`$ curl http://EXTERNAL-IP/api/v2/simulation`

We can then access the stub via e.g.
`$ curl http://EXTERNAL-IP:8500/bar`

---
## Features
-	Stand up a new stub namespace inside Kubernetes (I’m going with one namespace per stub, and I’ve confirmed that we can have multiple stub configs running simultaneously in their own namespace)
-	Automatically deploy a stub config to that namespace from a URL (e.g. github, Bamboo, CodeCommit, etc.) when the stub instance is created
    -	Each stub instance initially gets 100Mb RAM, and is capped at 200Mb. That’s to prevent one load test from taking over the entire cluster and blocking other projects
    -	Each stub instance runs a healthcheck every 2 seconds, and will be killed off and restarted if it fails that check
-	Stand up a load balancer (Kubernetes Service) in front of that stub, and expose the load balancer IP address to the Internet
    -	Each namespace gets its own IP address, so we can run e.g. one stub per team or one stub per backend system
-	Auto scale that stub (currently up to 30 instances, but that’s easily changed), based on CPU load
    -	New stub instances will try to load balance across data centres, so that the service will stay up as long as there’s a single cloud data centre still running. I’ve got that working for GCP, but this is cloud-specific config that will need to be tweaked for AWS


## To do
- current config works for GCP; get it working for AWS + Azure
- document sample firewall or VPC rules for each cloud to restrict access
- create a test to confirm autoscaling works as it should
- scripts to shutdown most nodes to minimise resource usage out of business hours, then restart them in time for the next business day
-	block out the Hoverfly admin port, so nobody can reconfigure the stub after it’s deployed (stub config changes should be deployed via gitops only)
-	have it redeploy e.g. every 5 minutes, so any change to the stub config in the “master” branch of the relevant repo will automatically be deployed
-	make it resilient for more failure scenarios (e.g. loss of node), and build some chaos testing around it to validate
-	as all the config is held in YAML files and some of that is specific to the stub instance, identify a generic tool for manipulating those YAML files and implement scripts around it
-	get nicely formatted logs coming out from all stubs

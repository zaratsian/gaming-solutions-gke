# Gaming Solutions Framework on GKE

## Setup

1. Clone repo

2. Copy the config.default file

```
cp config.default config
```

3. Edit the config by adding in your own values

```
vi config
```

4. Run the setup script

```
./setup.sh
```

5. Test the GKE deployment using Curl

```
curl $EXTERNAL_IP
```

---

## Kubernets CMDs and Troubleshooting

```
kubectl get nods
```

```
kubectl apply -f deployment.yaml
# With env variable replacement
envsubst < deployment.yaml | kubectl apply -f -

kubectl get deployments

kubectl delete deployments base-app-python

kubectl get pods
```

```
kubectl apply -f service.yaml
# With env variable replacement
envsubst < service.yaml | kubectl apply -f -

kubectl get services

kubectl delete services base-app-python

kubectl get services base-app-python --output jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

```
# Inspect events (debugging)
kubectl get events --sort-by=.metadata.creationTimestamp
```
. config

gcloud config set project $GCP_PROJECT_ID

gcloud artifacts repositories create $ARTIFACT_REPO_NAME \
    --project=$GCP_PROJECT_ID \
    --repository-format=docker \
    --location=$GCP_REGION \
    --description="Gaming Repo for GKE"

gcloud builds submit \
    --tag $GCP_REGION-docker.pkg.dev/$GCP_PROJECT_ID/$ARTIFACT_REPO_NAME/base-app-python \
    ./containers/base_app_python/.

gcloud container clusters create $GKE_CLUSTER_NAME \
    --region $GCP_REGION \
    --num-nodes $GKE_NODES \
    --min-nodes $GKE_MIN_NODES \
    --max-nodes $GKE_MAX_NODES \
    --enable-autoscaling \
    --machine-type $GKE_MACHINE_TYPE

envsubst < deployment.yaml | kubectl apply -f -

envsubst < service.yaml | kubectl apply -f -

echo ""
echo "Waiting for External IP to be available..."
sleep 60
export EXTERNAL_IP=$(kubectl get services base-app --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Testing Endpoint at $EXTERNAL_IP"
curl $EXTERNAL_IP
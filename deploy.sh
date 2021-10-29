# Build and push images. (tag it with latest GIT commit IDs)
docker build -t adighan/multi-client:latest -t adighan/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t adighan/multi-server:latest -t adighan/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t adighan/multi-worker:latest -t adighan/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push adighan/multi-client:latest
docker push adighan/multi-client:$SHA
docker push adighan/multi-server:latest
docker push adighan/multi-server:$SHA
docker push adighan/multi-worker:latest
docker push adighan/multi-worker:$SHA

# Apply k8s configs
kubectl apply -f k8s

# Imperative declaration - Force kubernetes to use the latest image version.
kubectl set image deployments/server-deployment server=adighan/multi-server:$SHA
kubectl set image deployments/client-deployment client=adighan/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=adighan/multi-worker:$SHA
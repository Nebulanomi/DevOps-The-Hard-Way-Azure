#/bin/bash

name="acrdevopsthehardwayazurecr"

# Pull a test image and push to your ACR
echo "Pulling a test image from Docker Hub"
docker pull hello-world
echo ""

echo "Tagging the image to ACR..."
docker tag hello-world $name.azurecr.io/hello-world:1
echo ""

echo "Pushing the image to ACR..."
docker push $name.azurecr.io/hello-world:1
echo ""
# Use Immutable Tags in Production: For production scenarios, consider using unique tags for each image build (like commit hashes or build IDs) rather than reusing tags like "latest".

# Example using a timestamp for unique tagging
echo "Tagging and pushing with a unique build ID..."
BUILD_ID=$(date +%Y%m%d%H%M%S)
docker tag nebulanomi:latest azurecrdevopsthehardway.azurecr.io/nebulanomi:$BUILD_ID
docker push azurecrdevopsthehardway.azurecr.io/nebulanomi:$BUILD_ID
echo ""

# Enable Image Scanning at subscription level:
echo "Enabling image scanning in ACR..."
az acr update --name azurecrdevopsthehardway --enable-defender
echo ""

# Set Up Geo-replication for Production: For high-availability production scenarios, consider enabling geo-replication of your ACR (Needs to be premium SKU):
echo "Setting up geo-replication for ACR..."
az security pricing create --name Containers --tier standard
echo ""

# CI/CD Integration: Set up CI/CD pipelines to automatically build and push your Docker images to ACR whenever you make changes to your application code. This approach maintains consistent image tagging and versioning across environments.

# Consider Repository Retention Policies: For busy repositories, set up retention policies to automatically clean up older images (Needs to be premium SKU):
echo "Setting up retention policies in ACR..."
az acr config retention update --registry azurecrdevopsthehardway --status enabled --days 30 --type UntaggedManifests
echo ""


# Build with platform specification for compatibility
# Normal docker build will build for your local machine’s architecture (e.g., arm64 on Apple Silicon Macs, amd64 on most Linux servers)
# docker buildx build --platform linux/amd64 lets you target a specific platform, even if you’re on a different one
# You can also build multi-arch images that work on both
echo "Building Docker image for nebulanomi..."
docker buildx build \
  --platform linux/amd64 \
  -t nebulanomi:latest .
echo ""

# List Docker images
echo "Listing Docker images..."
docker images | grep nebulanomi
echo ""

# Run in detached mode with port mapping
echo "Running test container..."
docker run -d -p 8080:5000 --name nebulanomi-test nebulanomi:latest
echo ""

# Check container is running
echo "Checking running containers..."
docker ps
echo ""

# Test HTTP endpoint
echo "Testing HTTP endpoint..."
curl http://localhost:6000
echo ""

# Stop and remove test container
echo "Cleaning up test container..."
docker stop nebulanomi-test
docker rm nebulanomi-test
echo ""
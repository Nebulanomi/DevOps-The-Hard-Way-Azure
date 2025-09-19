# Comprehensive validation script
echo "🔍 Validating Docker build..."

# Check image exists
if docker images | grep -q "nebulanomi"; then
    echo "✅ Docker image created successfully"
else
    echo "❌ Docker image not found"
    exit 1
fi

# Check image size (should be reasonable)
IMAGE_SIZE=$(docker images nebulanomi:latest --format "table {{.Size}}" | tail -n 1)
echo "📊 Image size: $IMAGE_SIZE"

# Test container run
echo "🚀 Testing container..."
CONTAINER_ID=$(docker run -d -p 6000:5000 nebulanomi:latest)

# Wait for startup
sleep 3

# Test HTTP response
if curl -s http://localhost:8080 | grep -q "nebulanomi"; then
    echo "✅ Application responding correctly"
else
    echo "❌ Application not responding properly"
fi

# Cleanup
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID

echo "✅ Validation complete!"
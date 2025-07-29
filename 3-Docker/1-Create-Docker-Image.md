# Creating the Docker Image for the Thomasthornton.cloud App

## 🎯 **Tutorial Overview**
**Difficulty:** 🟢 **Beginner**  
**Estimated Time:** ⏱️ **15-20 minutes**  
**Prerequisites Level:** Basic Docker knowledge helpful

In this lab, you'll containerize the Thomasthornton.cloud Python Flask application and run it locally using Docker.

### 📋 **Learning Objectives**
By the end of this tutorial, you will:
- [ ] Understand Docker containerization concepts
- [ ] Build a Docker image for a Python Flask application
- [ ] Run and test containerized applications locally
- [ ] Understand multi-stage builds and optimization
- [ ] Tag images for registry deployment
- [ ] Validate container functionality and security

### ⚠️ **Important Notes**
- Ensure Docker Desktop is running before starting
- Image will be ~100MB due to Python base image
- Container runs on port 5000 by default
- Application includes health check endpoints

## 🛠️ Create The Docker Image

### ✅ **Prerequisites Checklist**
Before starting, ensure you have:
- [ ] **Docker Desktop** installed and running
- [ ] **Terminal/Command Prompt** access
- [ ] **Text editor** for viewing configuration files
- [ ] Basic understanding of containerization concepts
- [ ] Python Flask application files available

### 📚 **Background Knowledge**
**What is Docker?**
- Containerization platform for packaging applications
- Provides consistent runtime environment
- Isolates applications from host system
- Enables portable deployments across environments

**Key Docker Concepts:**
- **Image:** Read-only template for containers
- **Container:** Running instance of an image
- **Dockerfile:** Instructions for building images
- **Registry:** Storage for Docker images

## 🚀 **Step-by-Step Implementation**

### **Step 1: Explore Application Structure** ⏱️ *5 minutes*

1. **📂 Navigate to Docker Directory**
   ```bash
   cd 3-Docker
   ```

2. **🔍 Review Application Structure**
   ```bash
   ls -la
   # Expected files:
   # - Dockerfile
   # - app/
   #   ├── app.py
   #   ├── requirements.txt
   #   └── templates/
   #       └── index.html
   ```

   **📋 Application Components:**
   - [ ] **app.py** - Flask web application
   - [ ] **requirements.txt** - Python dependencies
   - [ ] **templates/** - HTML templates
   - [ ] **Dockerfile** - Container build instructions

### **Step 2: Understand Dockerfile Configuration** ⏱️ *5 minutes*

3. **📄 Review the Dockerfile**
   ```dockerfile
   # Key components explained:
   FROM python:3.13-slim              # Base image
   WORKDIR /app                       # Working directory
   COPY requirements.txt /app/        # Copy dependencies first
   RUN pip install --no-cache-dir -r requirements.txt  # Install deps
   COPY app/ /app/                    # Copy application code
   EXPOSE 5000                        # Expose port
   CMD ["python", "app.py"]           # Start command
   ```

   **🎯 Dockerfile Best Practices Implemented:**
   - [ ] **Multi-layer caching** - Dependencies copied separately
   - [ ] **Slim base image** - Reduces attack surface and size
   - [ ] **Non-root user** - Enhanced security
   - [ ] **Health checks** - Container monitoring
   - [ ] **Clear working directory** - Organized file structure

### **Step 3: Build Docker Image** ⏱️ *8 minutes*

4. **🏗️ Build the Container Image**
   ```bash
   # Build with platform specification for compatibility
   docker build --platform linux/amd64 -t thomasthorntoncloud:latest .
   ```
   
   **⏱️ Build Process:** 2-3 minutes
   **✅ Expected Output:**
   ```
   [+] Building 45.2s (10/10) FINISHED
   => [internal] load build definition from Dockerfile
   => => transferring dockerfile: 234B
   => [internal] load .dockerignore
   => ...
   => => naming to docker.io/library/thomasthorntoncloud:latest
   ```

5. **📋 Verify Image Creation**
   ```bash
   # List Docker images
   docker images | grep thomasthorntoncloud
   ```
   **✅ Expected:** Image listed with latest tag and size ~100MB
### **Step 4: Test Docker Container Locally** ⏱️ *5 minutes*

6. **🚀 Run Container Locally**
   ```bash
   # Run in detached mode with port mapping
   docker run -d -p 5000:5000 --name thomasthorntoncloud-test thomasthorntoncloud:latest
   ```

7. **🔍 Verify Container Status**
   ```bash
   # Check container is running
   docker ps
   ```
   **✅ Expected:** Container status shows "Up" with port 5000:5000

8. **🌐 Test Application Response**
   ```bash
   # Test HTTP endpoint
   curl http://localhost:5000
   ```
   **✅ Expected:** HTML response containing "Thomas Thornton Cloud"

   **🖥️ Browser Test:** Navigate to `http://localhost:5000`

9. **🧹 Cleanup Test Container**
   ```bash
   # Stop and remove test container
   docker stop thomasthorntoncloud-test
   docker rm thomasthorntoncloud-test
   ```

## ✅ **Validation Steps**

**🔍 Build Validation:**
- [ ] Docker image created successfully (`docker images` shows your image)
- [ ] Image size reasonable (~100MB for Python slim)
- [ ] No build errors or warnings in output

**🚀 Runtime Validation:**
- [ ] Container starts without errors
- [ ] Application responds on port 5000
- [ ] HTML content loads correctly
- [ ] No runtime errors in container logs (`docker logs <container-name>`)

**🔧 Technical Validation:**
```bash
# Comprehensive validation script
echo "🔍 Validating Docker build..."

# Check image exists
if docker images | grep -q "thomasthorntoncloud"; then
    echo "✅ Docker image created successfully"
else
    echo "❌ Docker image not found"
    exit 1
fi

# Check image size (should be reasonable)
IMAGE_SIZE=$(docker images thomasthorntoncloud:latest --format "table {{.Size}}" | tail -n 1)
echo "📊 Image size: $IMAGE_SIZE"

# Test container run
echo "🚀 Testing container..."
CONTAINER_ID=$(docker run -d -p 5001:5000 thomasthorntoncloud:latest)

# Wait for startup
sleep 3

# Test HTTP response
if curl -s http://localhost:5001 | grep -q "Thomas Thornton"; then
    echo "✅ Application responding correctly"
else
    echo "❌ Application not responding properly"
fi

# Cleanup
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID

echo "✅ Validation complete!"
```

## 🚨 **Troubleshooting Guide**

**❌ Build Failures:**
```bash
# Problem: "no such file or directory"
# Solution: Ensure you're in the 3-Docker directory
pwd  # Should show: .../3-Docker

# Problem: Python package installation fails
# Solution: Check requirements.txt syntax
cat app/requirements.txt

# Problem: Platform compatibility issues
# Solution: Specify platform explicitly
docker build --platform linux/amd64 -t thomasthorntoncloud:latest .
```

**🔧 Runtime Issues:**
```bash
# Problem: Container exits immediately
# Solution: Check application logs
docker logs <container-name>

# Problem: Port already in use
# Solution: Use different port or stop conflicting service
docker run -p 8080:5000 thomasthorntoncloud:latest  # Use port 8080

# Problem: Application not accessible
# Solution: Verify port mapping and firewall
docker port <container-name>  # Check port mapping
netstat -an | grep 5000      # Check if port is listening
```

**🧹 Common Cleanup Commands:**
```bash
# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove everything (use with caution)
docker system prune -a
```

## 💡 **Knowledge Check**

**🎯 Quick Quiz:**
1. What base image does our Dockerfile use and why?
2. Which port does the Flask application expose?
3. How do you verify a Docker image was built successfully?
4. What's the difference between `docker run` and `docker run -d`?

**� Answers:**
1. `python:3.13-slim` - Provides Python runtime with minimal attack surface
2. Port `5000` - Default Flask development port
3. Use `docker images` command to list built images
4. `-d` runs container in detached mode (background)

## 🎯 **Next Steps**

**✅ Upon Completion:**
- [ ] Docker image built and tested locally
- [ ] Application accessible via HTTP
- [ ] Understanding of container fundamentals
- [ ] Ready to push image to Azure Container Registry

**➡️ Continue to:** [Push Image to ACR](./2-Push%20Image%20To%20ACR.md)

---

## 📚 **Additional Resources**

- 🔗 [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- 🔗 [Flask Deployment Guide](https://flask.palletsprojects.com/en/2.3.x/deploying/)
- 🔗 [Container Security](https://docs.docker.com/engine/security/)

4. **Using Docker Compose**: For more complex applications with multiple services, consider using Docker Compose:
   ```bash
   docker-compose up -d
   ```
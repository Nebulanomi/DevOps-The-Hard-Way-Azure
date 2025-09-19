# ❌ Build Failures:

# Problem: "no such file or directory"
# Solution: Ensure you're in the 3-Docker directory
pwd  # Should show: .../3-Docker

# Problem: Python package installation fails
# Solution: Check requirements.txt syntax
cat app/requirements.txt

# Problem: Platform compatibility issues
# Solution: Specify platform explicitly
docker build --platform linux/amd64 -t nebulanomi:latest .

# ---
# 🔧 Runtime Issues:

# Problem: Container exits immediately
# Solution: Check application logs
docker logs <container-name>

# Problem: Port already in use
# Solution: Use different port or stop conflicting service
docker run -p 8080:5000 nebulanomi:latest  # Use port 8080

# Problem: Application not accessible
# Solution: Verify port mapping and firewall
docker port <container-name>  # Check port mapping
netstat -an | grep 5000      # Check if port is listening
# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove everything (use with caution)
docker system prune -a
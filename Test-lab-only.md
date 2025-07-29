# Below is for testing the lab setup only

### Automated Deployment

For a complete automated deployment and testing experience:

```bash
# Clone the repository
git clone https://github.com/thomast1906/DevOps-The-Hard-Way-Azure.git
cd DevOps-The-Hard-Way-Azure


# Or deploy everything and keep it running
./scripts/deploy-all.sh

# Clean up everything when done
./scripts/cleanup-all.sh
```

### GitHub Actions Deployment

The repository includes a comprehensive GitHub Actions workflow for automated deployment:

1. **Fork this repository**
2. **Set up Azure OIDC secrets** in your repository settings:
   - `AZURE_AD_CLIENT_ID`
   - `AZURE_AD_TENANT_ID` 
   - `AZURE_SUBSCRIPTION_ID`
3. **Trigger the workflow**:
   - Push to `main` branch, or
   - Use workflow dispatch with custom options

The GitHub Actions workflow can deploy to different environments and optionally clean up resources after testing.
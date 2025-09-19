# Issue: "Invalid SSH public key"

# Validate SSH key format
ssh-keygen -l -f ~/.ssh/your_key.pub

# Regenerate if needed
ssh-keygen -t rsa -b 4096 -f ~/.ssh/aks_key -N ""

# ---
# Issue: "Quota exceeded"

# Check current usage
az vm list-usage --location "uksouth" --query "[?name.value=='cores']"
# Request quota increase in Azure Portal

# ---
# Issue: "Cannot connect to cluster"

# Verify credentials
az aks get-credentials --resource-group "rg-name" --name "cluster-name" --overwrite-existing

# Check Azure AD authentication
az aks get-versions --location "uksouth"

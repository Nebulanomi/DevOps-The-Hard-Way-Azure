# Add to your shell profile (.bashrc, .zshrc, etc.)
export AZURE_RESOURCE_GROUP="rg-devopsthehardway"
export AZURE_LOCATION="westeurope"
export TUTORIAL_PATH="$HOME/devops_the_hard_way"

# Source your profile (Restart terminal)
source ~/.zshrc  # or ~/.bashrc

# Echo to confirm
echo "Environment variables set:"
echo "AZURE_RESOURCE_GROUP=$AZURE_RESOURCE_GROUP"
echo "AZURE_LOCATION=$AZURE_LOCATION"
echo "TUTORIAL_PATH=$TUTORIAL_PATH"
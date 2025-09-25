# Add the universe repository to get graphviz
sudo add-apt-repository universe

# Install graphviz to convert the DOT format to SVG
sudo add-apt-repository universe

# Generate the graph in SVG format
cd ~/devops_the_hard_way/2-terraform/1-acr
terraform graph | dot -Tsvg > graph.svg
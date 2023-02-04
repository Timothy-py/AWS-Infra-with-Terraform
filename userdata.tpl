#!/bin/bash

# # Update the package index
# sudo apt-get update

# # Install the dependencies for Docker installation
# sudo apt-get install -y \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     gnupg-agent \
#     software-properties-common

# # Add the Docker GPG key
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# # Add the Docker repository to the sources list
# sudo add-apt-repository \
#     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#    $(lsb_release -cs) \
#    stable"

# # Update the package index again
# sudo apt-get update

# # Install the latest version of Docker
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# # Start the Docker service
# sudo systemctl start docker

# # Enable the Docker service to start at boot
# sudo systemctl enable docker

# # Add ubuntu user to docker group
# sudo usermod -aG docker ubuntu

# update the package list
sudo apt-get update

# install Apache web server
sudo apt-get install -y apache2

# set the timezone to Africa/Lagos
sudo timedatectl set-timezone Africa/Lagos

# create an HTML file to display on the web server
sudo bash -c "echo '<html><body><h1>Hello from EC2!</h1></body></html>' > /var/www/html/index.html"

# restart Apache to pick up the changes
sudo service apache2 restart

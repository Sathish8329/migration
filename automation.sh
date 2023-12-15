#!/bin/bash
#CLONE, INSTALL & CHANGE ENV FILE#
# Set your Azure DevOps credentials
username="nk.murugesan"
password="iusbzr3igmencie4cv5xeqiamis2jwytgkviemdpis3n24roi22a"

# Set the IP address variable
ip_address="13.201.44.206"

# Set the Git repository URL and UI directory
auth_url="dev.azure.com/kovaionai/timesheet-baseline/_git/auth"
directory="auth"
backend_url="dev.azure.com/kovaionai/Generic-Workflows/_git/generic-workflows-backend"
backend="generic-workflows-backend"
frontend_url="dev.azure.com/kovaionai/Generic-Workflows/_git/generic-workflows-frontend"
frontend="generic-workflows-frontend"
branch="Stage_LowCode"

# Define the domains
frontenddomain="http://13.201.44.206:3000"
backenddomain="http://13.201.44.206:8000/api/v1/"
authdomain="http://13.201.44.206:8080/api/v1/"

# Exit immediately if any command exits with a non-zero status
set -e

# Function to handle errors and print a message
handle_error() {
  echo "Error occurred in script at line $1"
}

# Trap for errors
trap 'handle_error $LINENO' ERR

# Update package lists
sudo apt update

# Install Git
sudo apt install git -y

# Install npm
sudo apt install npm -y

# Install n (Node.js version manager) and Node.js 14
sudo npm install -g n
sudo n install 14

# Install pm2 (Process Manager for Node.js applications)
sudo npm install -g pm2

# Install Nginx
sudo apt install nginx -y

# Install Certbot for Nginx
sudo apt install python3-certbot-nginx -y

# Function to handle errors and print a message
handle_error() {
  echo "Error occurred in script at line $1"
}

# Trap for errors
trap 'handle_error $LINENO' ERR

mkdir app
cd app

# Clone the Git repository
echo "Cloning Git repository..."
auth_repo_url="https://${username}:${password}@$auth_url"
git clone -b "$branch" "$auth_repo_url"

# Change to the UI directory
cd "$directory"

# Install npm dependencies and force reinstall
npm install --force

cd ..

# Clone the Git repository
echo "Cloning Git repository..."
backend_repo_url="https://${username}:${password}@$backend_url"
git clone -b "$branch" "$backend_repo_url"

# Change to the UI directory
cd "$backend"

# Install npm dependencies and force reinstall
npm install --force

cd ..

# Clone the Git repository
echo "Cloning Git repository..."
frontend_repo_url="https://${username}:${password}@$frontend_url"
git clone -b "$branch" "$frontend_repo_url"

# Change to the UI directory
cd "$frontend"

# Install npm dependencies and force reinstall
npm install --force

# Specify the file path for the first file
FILE_PATH_1="/home/ubuntu/app/auth/.env"

# Use sed to replace the values in the first file
sed -i "s|FRONT_END_URL =.*|FRONT_END_URL = $frontenddomain|" "$FILE_PATH_1"
sed -i "s|FRONT_END_DOMAIN =.*|FRONT_END_DOMAIN = $frontenddomain|" "$FILE_PATH_1"

echo "Text in $FILE_PATH_1 updated successfully."

# Specify the file path for the second file
FILE_PATH_2="/home/ubuntu/app/generic-workflows-frontend/.env.development"

# Use sed to replace the values in the second file
sed -i "s|REACT_APP_API_BASE_URL=.*|REACT_APP_API_BASE_URL= $backenddomain|" "$FILE_PATH_2"
sed -i "s|REACT_APP_API_AUTH_URL =.*|REACT_APP_API_AUTH_URL = $authdomain|" "$FILE_PATH_2"

echo "Text in $FILE_PATH_2 updated successfully."


# Print versions at the end
echo "Installed versions:"
echo "Git: $(git --version)"
echo "npm: $(npm --version)"
echo "Node.js: $(node --version)"
echo "pm2: $(pm2 --version)"
echo "Nginx: $(nginx -v 2>&1)"
echo "Certbot: $(certbot --version)"

#!/bin/bash
#CLONE, INSTALL & CHANGE ENV FILE#
# Set your Azure DevOps credentials

username="*******"
password="*******"

# Set the IP address variable
ip_address="3.110.50.37"

# Set the Git repository URL and UI directory
auth_url="dev.azure.com/kovaionai/timesheet-baseline/_git/auth"
directory="auth"
backend_url="dev.azure.com/kovaionai/Generic-Workflows/_git/generic-workflows-backend"
backend="generic-workflows-backend"
frontend_url="dev.azure.com/kovaionai/Generic-Workflows/_git/generic-workflows-frontend"
frontend="generic-workflows-frontend"
branch="stage_lowcode_261223"

# Define the domains
frontenddomain="https://q4-2023-stage2.kovaion.ai"
backenddomain="https://q4-2023-stage2.kovaion.ai/backend/api/v1/"
authdomain="https://q4-2023-stage2.kovaion.ai/auth/api/v1/"
subdomain="q4-2023-stage2" #landing page
authdomain1="https://q4-2023-stage2.kovaion.ai/auth"
subdomainIP="3.110.50.37"

mongodb="mongodb+srv://doadmin:3TtE8eidr017926A@mongodb-kovaion-stage-093f050e.mongo.ondigitalocean.com"
doadmin="doadmin:3TtE8eidr017926A@mongodb-kovaion-stage-093f050e.mongo.ondigitalocean.com" #start from username ie omit the mongodb+srv://
admindb="superadmin"

# Define Redis Host and Port
#REDIS_HOST = 127.0.0.1
#REDIS_PORT = 6379
slug="f94eca9b-ad9d-42ec-861c-157631dad3ff" #resellerslug variable

# Exit immediately if any command exits with a non-zero status
set -e

set -x
# landing page - frontend .env.development src/router/index.js
#  auth src/routes/login/handler/login.controller.js - .env
#  Reseller slug - backend .env
#   admin_db=superadmin instead of demo-admin backend.env need to add entry
# sub_domain_prefix = q4-2023-stage (domainname) backend.env
#  mongodb url change in both backend and auth .env

#Preparation deleting the existing file
rm -rf /root/webhook/scripts/app

#Deleting existing PM2
#PM2 delete all

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
sudo n install 18

# Install pm2 (Process Manager for Node.js applications)
sudo npm install -g pm2

#sudo apt-get install nodejs

# Install Nginx
sudo apt install nginx -y

# Install Certbot for Nginx
sudo apt install python3-certbot-nginx -y
# Run the Redis server

#sudo apt-get install redis-server
#redis-server

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

rm -rf "$frontend"

# Clone the Git repository
echo "Cloning Git repository..."
frontend_repo_url="https://${username}:${password}@$frontend_url"
git clone -b "$branch" "$frontend_repo_url"

# Change to the UI directory
cd "$frontend"

# Install npm dependencies and force reinstall
npm install --force

# Specify the file path for the first file
FILE_PATH_1="/root/webhook/scripts/app/auth/.env"

# Use sed to replace the values in the first file
sed -i "s|FRONT_END_URL =.*|FRONT_END_URL = $frontenddomain|" "$FILE_PATH_1"
sed -i "s|FRONT_END_DOMAIN =.*|FRONT_END_DOMAIN = $frontenddomain|" "$FILE_PATH_1"
sed -i 's|DOMAIN_NAME[[:space:]]*=[[:space:]]*".*"|DOMAIN_NAME = "'"$subdomain"'"|' "$FILE_PATH_1"
sed -i "s|MAIN_DB_URL =.*|MAIN_DB_URL = $mongodb|" "$FILE_PATH_1"
sed -i "s|MAIN_HOST =.*|MAIN_HOST = $doadmin|" "$FILE_PATH_1"
#sed -i 's|SUB_DOMAIN[[:space:]]*=[[:space:]]*".*"|SUB_DOMAIN = "'"$subdomain"'"|' "$FILE_PATH_1"
sed -i "s|SUB_DOMAIN[[:space:]]*=[[:space:]]*\".*\"|SUB_DOMAIN = \"$subdomain\"|" "$FILE_PATH_1"

echo "Text in $FILE_PATH_1 updated successfully."

# Specify the file path for the second file
FILE_PATH_2="/root/webhook/scripts/app/generic-workflows-frontend/.env.development"

# Use sed to replace the values in the second file
sed -i "s|REACT_APP_API_BASE_URL=.*|REACT_APP_API_BASE_URL= $backenddomain|" "$FILE_PATH_2"
sed -i "s|REACT_APP_API_AUTH_URL =.*|REACT_APP_API_AUTH_URL = $authdomain|" "$FILE_PATH_2"
#sed -i "s|LANDING_PAGE=.*|LANDING_PAGE= "$subdomain"|" "$FILE_PATH_2"
sed -i "s|LANDING_PAGE=.*|LANDING_PAGE=\"$subdomain\"|" "$FILE_PATH_2"

echo "Text in $FILE_PATH_2 updated successfully."

FILE_PATH_3="/root/webhook/scripts/app/generic-workflows-backend/.env"

# Use sed to replace the values in the third file
sed -i "s|AUTH_API_URL[[:space:]]*=[[:space:]]*https://.*|AUTH_API_URL=$authdomain1|" "$FILE_PATH_3"
sed -i "s|FRONT_END_URL[[:space:]]*=[[:space:]]*https://.*|FRONT_END_URL=$frontenddomain|" "$FILE_PATH_3"
sed -i "s|REDIS_HOST[[:space:]]*=[[:space:]]*.*|REDIS_HOST=$Redis_Host|" "$FILE_PATH_3"
sed -i "s|REDIS_PORT[[:space:]]*=[[:space:]]*.*|REDIS_PORT=$Redis_Port|" "$FILE_PATH_3"
sed -i "s|RESELLER_SLUG[[:space:]]*=[[:space:]]*.*|RESELLER_SLUG=$slug|" "$FILE_PATH_3"
sed -i "s|SUB_DOAMIN_IP[[:space:]]*=[[:space:]]*.*|SUB_DOAMIN_IP=$subdomainIP|" "$FILE_PATH_3"
sed -i "s|MAIN_DB_URL =.*|MAIN_DB_URL = $mongodb|" "$FILE_PATH_3"
sed -i "s|DEMO_MAIN_HOST =.*|DEMO_MAIN_HOST = $mongodb|" "$FILE_PATH_3"
sed -i "s|^MAIN_HOST[[:space:]]*=[[:space:]]*.*|MAIN_HOST = $doadmin|" "$FILE_PATH_3"
sed -i "s|^SUB_DOMAIN_PREFIX[[:space:]]*=[[:space:]]*.*|SUB_DOMAIN_PREFIX = $subdomain|" "$FILE_PATH_3"
sed -i "s|^ADMIN_DB[[:space:]]*=[[:space:]]*.*|ADMIN_DB = $admindb|" "$FILE_PATH_3"

echo "Text in $FILE_PATH_3 updated successfully."


# Print versions at the end
echo "Installed versions:"
echo "Git: $(git --version)"
echo "npm: $(npm --version)"
echo "Node.js: $(node --version)"
echo "pm2: $(pm2 --version)"
echo "Nginx: $(nginx -v 2>&1)"
echo "Certbot: $(certbot --version)"


cd ..
#pm2 delete all

# Get the list of PM2 process IDs
#pm2_ids=$(pm2 list | awk '{if(NR>2)print $2}')

# Iterate over each process ID and delete it
#for id in $pm2_ids; do
#    pm2 delete $id
#done

cd /root/webhook/scripts/app/$directory
npm run build
#sudo cp /.env.auth .env

pm2 start "npm start" --name auth

cd
cd /root/webhook/scripts/app/$backend
#sudo cp /.env-backend ./.env
npm run build
pm2 start "npm start" --name backend

cd
cd /root/webhook/scripts/app/$frontend
npm run build
sudo cp -r build/* /var/www/html
pm2 start "npm start" --name frontend

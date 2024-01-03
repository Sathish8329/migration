#!/bin/bash

set +e
set +x
# Install required packages
sudo apt install software-properties-common gnupg apt-transport-https ca-certificates -y

# Add MongoDB GPG key
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Add MongoDB repository to sources list
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update package information
sudo apt update

# Install MongoDB
sudo apt install mongodb-org -y

# Start MongoDB service
sudo systemctl start mongod

# Check MongoDB service status
sudo systemctl status mongod

# Check for MongoDB listening on port 27017
sudo ss -pnltu | grep 27017

# Enable MongoDB to start on boot
sudo systemctl enable mongod

mongodump --uri="mongodb+srv://doadmin:3TtE8eidr017926A@mongodb-kovaionprod-bk-18dec23-d2357f77.mongo.ondigitalocean.com/engage?authSource=admin&replicaSet=mongodb-kovaionprod-bk-18dec23&readPreference=primary&appname=MongoDB%20Compass&ssl=true" --out /home/newdump

mongorestore --uri="mongodb+srv://doadmin:3TtE8eidr017926A@mongodb-kovaion-stage-093f050e.mongo.ondigitalocean.com" -u doadmin -p 3TtE8eidr017926A --authenticationDatabase admin --db q4-2023-stage2-engage /home/newdump/engage

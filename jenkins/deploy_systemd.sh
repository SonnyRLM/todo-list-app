#!/bin/bash

# Install application to /opt/
rm -r /opt/todo-list
mkdir /opt/todo-list
cp -r . /opt/todo-list

#Perms
sudo chown -R jenkins /opt

# Generate service file
cat << EOF > todo-list.service
[Unit]
Description=Todo List

[Service]
User=jenkins
Environment=DATABASE_URI=$DATABASE_URI
Environment=SECRET_KEY=$SECRET_KEY
ExecStart=sh /opt/todo-list/jenkins/startup.sh


# Systemd service configuration here
# You'll need to set these environment variables:
#     DATABASE_URI
#     SECRET_KEY
# 
# Use the jenkins/setup.sh script to start the app
# 
# Attach the user either to jenkins or (preferably) 
# dedicated service user, e.g. pythonadm
# ----------------------------------
# Configuration
# ----------------------------------

[Install]
WantedBy=multi-user.target
EOF

# Move service file to systemd
sudo cp todo-list.service /etc/systemd/system/todo-list.service

# systemd reload/start/stop
sudo systemctl daemon-reload
sudo systemctl stop todo-list
sudo systemctl start todo-list

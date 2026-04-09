#!/bin/bash
sudo apt-get update
sudo apt install nodejs npm -y
cd /home/admin
sudo mkdir myapp
cd myapp
git clone https://github.com/austinlucyy/express.git
cd express
sudo npm init -y
sudo npm install express
sudo npm install -g pm2
sudo pm2 startup
sudo pm2 start app.js --watch
#! /bin/bash
sudo apt-get update
sudo apt-get -y install nginx
sudo systemctl enable nginx
sudo systemctl start nginx


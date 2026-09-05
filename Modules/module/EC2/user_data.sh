#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
#remove index.html
rm -f /var/www/html/index.html
echo "<h1> HELLO UMAA !!!</h1>" > /var/www/html/index.html
systemctl restart nginx
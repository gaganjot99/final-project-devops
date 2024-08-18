#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<style>body { background-image: url('https://gaganjot-images.s3.amazonaws.com/img3.jpg');background-size: cover;}h1{background-color:wheat;text-align: center;}</style><h1>Hi, This is Gaganjot's server from public subnet! My private IP is $myip <font color="Green"> in ${env} env</font></h1>"  >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd

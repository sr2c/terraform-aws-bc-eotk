#!/usr/bin/env bash

set -e

aws s3 cp s3://${bucket_name}/configuration.zip /root/configuration.zip

cd /root
unzip configuration.zip
mv sites.conf /home/ubuntu/eotk/
chown ubuntu:ubuntu /home/ubuntu/eotk/sites.conf
mkdir -p /home/ubuntu/eotk/secrets.d
mv *.key /home/ubuntu/eotk/secrets.d/
chown ubuntu:ubuntu -R /home/ubuntu/eotk/secrets.d
chmod 640 /home/ubuntu/eotk/secrets.d/*.v3pub.key
chmod 600 /home/ubuntu/eotk/secrets.d/*.v3sec.key
cd /home/ubuntu/eotk
sudo -u ubuntu ./eotk configure sites.conf
mv /root/*.cert /root/*.pem /home/ubuntu/eotk/projects.d/sites.d/ssl.d/
chown ubuntu:ubuntu -R /home/ubuntu/eotk/projects.d/sites.d/ssl.d
chmod 640 /home/ubuntu/eotk/projects.d/sites.d/ssl.d/*-v3.cert
chmod 600 /home/ubuntu/eotk/projects.d/sites.d/ssl.d/*-v3.pem
sudo -u ubuntu ./eotk bounce sites

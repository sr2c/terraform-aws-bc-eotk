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
cd /home/ubuntu/eotk
sudo -u ubuntu ./eotk configure sites.conf
mv /root/*.cert /root/*.pem /home/ubuntu/eotk/projects.d/sites.d/ssl.d/
sudo -u ubuntu ./eotk bounce sites

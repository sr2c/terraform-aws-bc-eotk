#!/usr/bin/env bash

set -e

aws s3 cp s3://${bucket_name}/configuration.zip /root/configuration.zip

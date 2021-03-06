#!/bin/bash
#
# Rails Ready
#
# Author: Josh Frye <joshfng@gmail.com>
# Licence: MIT
#
# Contributions from: Wayne E. Seguin <wayneeseguin@gmail.com>
# Contributions from: Ryan McGeary <ryan@mcgeary.org>
#

ruby_version=$1
script_runner=$(whoami)
railsready_path=$2
log_file=$3

epel_repo_url="http://mirrors.servercentral.net/fedora/epel/6/i386/epel-release-6-7.noarch.rpm"

#echo "vars set: $ruby_version $railsready_path $log_file"

# Add the EPEL repo if centos
echo -e "\n=> Adding EPEL repo..."
rpm -Uvh $epel_repo_url
echo "==> done..."

# Update the system before going any further
echo -e "\n=> Updating system (this may take a while)..."
yum update --nogpgcheck -y >> $log_file 2>&1
echo "==> done..."

# Install build tools
echo -e "\n=> Installing build tools..."
yum install -y --nogpgcheck gcc-c++ patch \
 readline readline-devel zlib zlib-devel \
 libyaml-devel libffi-devel openssl-devel \
 make automake bash curl sqlite-devel mysql-devel >> $log_file 2>&1
echo "==> done..."

# Install imagemagick
echo -e "\n=> Installing imagemagick (this may take a while)..."
yum install -y --nogpgcheck ImageMagick >> $log_file 2>&1
echo "==> done..."

# Install Git
echo -e "\n=> Installing git..."
yum install -y --nogpgcheck git >> $log_file 2>&1
echo "==> done..."

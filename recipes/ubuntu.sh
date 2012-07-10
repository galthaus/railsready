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

#echo "vars set: $ruby_version $railsready_path $log_file"

#test if aptitude exists and default to using that if possible
if command -v aptitude >/dev/null 2>&1 ; then
  pm="aptitude"
else
  pm="apt-get"
fi

echo -e "\nUsing $pm for package installation\n"

# Update the system before going any further
echo -e "\n=> Updating system (this may take a while)..."
$pm update >> $log_file 2>&1 \
 && $pm -y upgrade >> $log_file 2>&1
echo "==> done..."

# Install build tools
echo -e "\n=> Installing build tools..."
$pm -y install \
    wget curl build-essential clang \
    bison openssl zlib1g \
    libxslt1.1 libssl-dev libxslt1-dev \
    libxml2 libffi-dev libyaml-dev \
    libxslt-dev autoconf libc6-dev \
    libreadline6-dev zlib1g-dev libcurl4-openssl-dev \
    libtool >> $log_file 2>&1
echo "==> done..."

echo -e "\n=> Installing libs needed for sqlite and mysql..."
$pm -y install libsqlite3-0 sqlite3 libsqlite3-dev libmysqlclient-dev >> $log_file 2>&1
echo "==> done..."

# Install imagemagick
echo -e "\n=> Installing imagemagick (this may take a while)..."
$pm -y install imagemagick libmagick9-dev >> $log_file 2>&1
echo "==> done..."

# Install git-core
echo -e "\n=> Installing git..."
$pm -y install git-core >> $log_file 2>&1
echo "==> done..."

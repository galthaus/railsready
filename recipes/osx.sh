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

echo -e "\nInstalling Homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/1209017)" >> $log_file 2>&1
echo "==> done..."

# Install imagemagick
echo -e "\n=> Installing imagemagick (this may take a while)..."
brew install imagemagick >> $log_file 2>&1
echo "==> done..."

# Install git-core
echo -e "\n=> Updating git..."
brew install git >> $log_file 2>&1
echo "==> done..."

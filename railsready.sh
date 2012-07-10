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
shopt -s nocaseglob
set -e

ruby_version="1.9.3"
script_runner=$(whoami)
railsready_path=$(cd && pwd)/railsready
log_file="$railsready_path/install.log"

control_c()
{
  echo -en "\n\n*** Exiting ***\n\n"
  exit 1
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

clear

echo "#################################"
echo "########## Rails Ready ##########"
echo "#################################"

#determine the distro
if [[ $MACHTYPE = *linux* ]] ; then
  distro_sig=$(cat /etc/issue)
  if [[ $distro_sig =~ ubuntu ]] ; then
    distro="ubuntu"
  elif [[ $distro_sig =~ centos ]] ; then
    distro="centos"
  fi
fi

echo -e "\n\n"
echo "!!! This script will update your system! Run on a fresh install only !!!"
echo "run tail -f $log_file in a new terminal to watch the install"

echo -e "\n"
echo "What this script gets you:"
echo " * An updated system"
echo " * Ruby $ruby_version"
echo " * Imagemagick"
echo " * libs needed to run Rails (sqlite, mysql, etc)"
echo " * Bundler, Passenger, and Rails gems"
echo " * Git"

echo -e "\nThis script is always changing."
echo "Make sure you got it from https://github.com/joshfng/railsready"

# Check if the user has sudo privileges.
sudo -v >/dev/null 2>&1 || { echo $script_runner has no sudo privileges ; exit 1; }

echo -e "\n\n!!! Set to install RVM for user: $script_runner !!! \n"

echo -e "\n=> Creating install dir..."
cd && cd railsready && touch install.log
echo "==> done..."

echo -e "\n=> Downloading and running recipe for $distro...\n"
#Download the distro specific recipe and run it, passing along all the variables as args
cd $railsready_path/recipes && bash $distro.sh $ruby_version $railsready_path $log_file
echo -e "\n==> done running $distro specific commands..."

#now that all the distro specific packages are installed lets get Ruby
#thanks wayneeseguin :)
echo -e "\n=> Installing RVM the Ruby enVironment Manager http://rvm.beginrescueend.com/rvm/install/ \n"
curl -O -L -k https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer
chmod +x rvm-installer
"$PWD/rvm-installer" >> $log_file 2>&1
[[ -f rvm-installer ]] && rm -f rvm-installer
echo -e "\n=> Setting up RVM to load with new shells..."
#if RVM is installed as user root it goes to /usr/local/rvm/ not ~/.rvm
echo '[[ -s "/usr/local/lib/rvm" ]] && source "/usr/local/lib/rvm"' >> /etc/profile.d/rvm.sh
echo "==> done..."

echo "=> Loading RVM..."
source /etc/profile.d/rvm.sh
echo "==> done..."
echo -e "\n=> Installing Ruby $ruby_version (this will take a while)..."
echo -e "=> More information about installing rubies can be found at http://rvm.beginrescueend.com/rubies/installing/ \n"
rvm install $ruby_version >> $log_file 2>&1
echo -e "\n==> done..."
echo -e "\n=> Using $ruby_version and setting it as default for new shells..."
echo "=> More information about Rubies can be found at http://rvm.beginrescueend.com/rubies/default/"
rvm --default use $ruby_version >> $log_file 2>&1
echo "==> done..."

# Reload bash
echo -e "\n=> Reloading shell so ruby and rubygems are available..."
source /etc/profile.d/rvm.sh
echo "==> done..."

echo -e "\n=> Updating Rubygems..."
gem update --system --no-ri --no-rdoc >> $log_file 2>&1
echo "==> done..."

echo -e "\n=> Installing Bundler, Passenger and Rails..."
gem install bundler passenger rails --no-ri --no-rdoc >> $log_file 2>&1
echo "==> done..."

echo -e "\n#################################"
echo    "### Installation is complete! ###"
echo -e "#################################\n"

echo -e "\n !!! logout and back in to access Ruby !!!\n"

echo -e "\n Thanks!\n-Josh\n"

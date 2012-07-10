#!/bin/bash

if [[ $MACHTYPE = *linux* ]] ; then
  distro_sig=$(cat /etc/issue)
  if [[ $distro_sig =~ ubuntu ]] ; then
    distro="ubuntu"
  elif [[ $distro_sig =~ centos ]] ; then
    distro="centos"
  elif [[ $distro_sig =~ "Red Hat" ]] ; then
    distro="redhat"
  fi
fi

if [ "$distro" == "" ] ; then
  echo "Distro not set!!"
  exit -1
fi

if [ "$distro" == "ubuntu" ] ; then
  apt-get install polipo
else # Redhat / Centos

# Add local and epel
  cat > /etc/yum.repos.d/local.repo <<EOF
[local]
name=Local CD Repo
baseurl=file:///mnt/cdrom
EOF
 
  epel_repo_url="http://mirrors.servercentral.net/fedora/epel/6/i386/epel-release-6-7.noarch.rpm"
  rpm -Uvh $epel_repo_url

  yum install polipo
fi

/etc/init.d/polipo stop
if [ -e /root/polipo.tgz ] ; then
  cd /var/cache
  tar -zxvf /root/polipo.tgz
  cd -

  # GREG: Update to use OFFLINE MODE
fi
/etc/init.d/polipo start

export http_proxy='http://127.0.0.1:8123/'
export https_proxy='http://127.0.0.1:8123/'

mkdir -p railsready/recipes
wget --no-check-certificate -O railsready/railsready.sh https://github.com/galthaus/railsready/raw/master/railsready.sh
wget --no-check-certificate -O railsready/recipes/centos.sh https://raw.github.com/galthaus/railsready/master/recipes/centos.sh
wget --no-check-certificate -O railsready/recipes/ubuntu.sh https://raw.github.com/galthaus/railsready/master/recipes/ubuntu.sh
cd railsready/recipes
ln -s centos.sh redhat.sh
cd -

cd railsready/
bash railsready.sh 2>&1 | tee -a railsready.out


# REDHAT: Add local and epel


#[local]
#name=Local CD Repo
#baseurl=file:///mnt/cdrom

#epel_repo_url="http://mirrors.servercentral.net/fedora/epel/6/i386/epel-release-6-7.noarch.rpm"

# Add the EPEL repo if centos
#echo -e "\n=> Adding EPEL repo..."
#rpm -Uvh $epel_repo_url
#echo "==> done..."


apt-get install polipo
# yum install polipo
export http_proxy='http://127.0.0.1:8123/'
export https_proxy='http://127.0.0.1:8123/'

/etc/init.d/polipo stop
# Copy Cache to Here
# /var/cache/polipo
/etc/init.d/polipo start

apt-get install git
#yum install git
git clone http://github.com/galthaus/railsready
cd railsready/
./railsready.sh 2>&1 | tee -a railsready.out


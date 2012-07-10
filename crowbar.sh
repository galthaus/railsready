apt-get install polipo
export http_proxy='http://127.0.0.1:8123/'
export https_proxy='http://127.0.0.1:8123/'

/etc/init.d/polipo stop
# Copy Cache to Here
# /var/cache/polipo
/etc/init.d/polipo start

apt-get install git
git clone http://github.com/galthaus/railsready
cd railsready/
./railsready.sh 2>&1 | tee -a railsready.out


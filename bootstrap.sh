apt-get update

apt-get -y upgrade

apt-get -y install git redis-server elasticsearch python3 python3-dev python-virtualenv postgresql postgresql-server-dev-9.4 gcc libffi-dev libncurses5-dev

curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs

ln -s /usr/share/elasticsearch/bin/elasticsearch /usr/local/bin/elasticsearch
ln -s /usr/bin/nodejs /usr/bin/node

git clone https://github.com/yunity/yunity-setup.git yunity
cd yunity

# configure local settings so that
# 1. we use the http github link (avoiding needing to trust host keys)
# 2. configure to use "sudo -u postgres <psql|createuser> -U postgres" form
cat <<EOF > local_settings.make
pg_user = postgres
pg = sudo -u \$(pg_user) \$(1) -U \$(pg_user)
EOF

# use https: protocol for all git commands
# 1. git clone the other project repos
# 2. when npm install gets a git repo
git config --global url."https://github.com/".insteadOf git@github.com:

# builds the project :)
make

# special git hooks to copy over static images
cp ./yunity-webapp-common/scripts/post-merge ./yunity-webapp-common/.git/hooks/
chmod +x ./yunity-webapp-common/.git/hooks/post-merge

# kill any previous running one (might be reprovisioning)
pm2 kill

# start all required services using pm2 process manager
pm2 start pm2.json

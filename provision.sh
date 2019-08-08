#!/usr/bin/env bash
set -ex

mkdir -p /etc/dpkg/dpkg.cfg.d
cat >/etc/dpkg/dpkg.cfg.d/01_nodoc <<EOF
path-exclude /usr/share/doc/*
path-include /usr/share/doc/*/copyright
path-exclude /usr/share/man/*
path-exclude /usr/share/groff/*
path-exclude /usr/share/info/*
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
EOF

export DEBIAN_FRONTEND=noninteractive
export APTARGS="-qq -o=Dpkg::Use-Pty=0"

systemctl stop apt-daily.service
systemctl kill --kill-who=all apt-daily.service

# wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily.service | fgrep -q dead)
do
  sleep 1;
done

apt-get clean ${APTARGS}
apt-get update ${APTARGS}

apt-get upgrade -y ${APTARGS}
apt-get dist-upgrade -y ${APTARGS}

# Installing packages
echo "Installing packages..."

which unzip jq wget &>/dev/null || {
apt-get update -y ${APTARGS}
apt-get install unzip jq wget -y ${APTARGS}
}

# build-essential
apt-get install -y build-essential libssl-dev --no-install-recommends ${APTARGS}

####################################
#   Installing nodejs and ember    #
####################################
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get update ${APTARGS}
apt-get install -y nodejs ${APTARGS}

# Install ember v3.11.0
npm install -g ember-cli@3.11.0

cat <<EOF > /etc/systemd/system/ember.service
[Unit]
Description=Ember CLI
After=network-online.target

[Service]
Restart=on-failure
WorkingDirectory=/home/ubuntu/www/
ExecStart=/usr/lib/node_modules/ember-cli/bin/ember serve /home/ubuntu/www/app/app.js

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

set +x

# Update to the latest kernel
apt-get install -y linux-generic linux-image-generic ${APTARGS}

# build-essential
apt-get install -y build-essential ${APTARGS}

# Hide Ubuntu splash screen during OS Boot, so you can see if the boot hangs
apt-get remove -y plymouth-theme-ubuntu-text
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
update-grub

# Reboot with the new kernel
shutdown -r now

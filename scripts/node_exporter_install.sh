#!/bin/bash
sudo apt update
VERSION=$(git ls-remote --refs --tags https://github.com/prometheus/node_exporter.git \
    | cut --delimiter='/' --fields=3     \
    | tr '-' '~'                         \
    | sort --version-sort                \
    | tail --lines=1)
RELEASE=$(echo ${VERSION//v})
wget https://github.com/prometheus/node_exporter/releases/download/$VERSION/node_exporter-$RELEASE.linux-amd64.tar.gz
tar -xvf node_exporter-$RELEASE.linux-amd64.tar.gz
sudo mv node_exporter-$RELEASE.linux-amd64/node_exporter  /usr/local/bin/
sudo useradd -rs /bin/false node_exporter
sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF'
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
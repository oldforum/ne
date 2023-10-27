#!/bin/bash

# 定义node_exporter版本
NODE_EXPORTER_VERSION="1.6.1"

# 下载node_exporter
curl -LO "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"

# 解压
tar xvfz node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

# 移动到/usr/local/bin目录
mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/

# 清理下载的文件
rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64*
    
# 创建node_exporter用户和组
useradd -rs /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# 创建systemd服务文件
cat <<EOL > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOL

# 重新加载systemd并启动node_exporter服务
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

echo "node_exporter安装和启动完毕！"

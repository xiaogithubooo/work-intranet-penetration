#!/bin/bash
### @author <a href="https://github.com/xiaogithubooo">limou3434</a> ###
### @from <a href="https://xxx.com">xxx</a> ###

### 生成客户端配置文件 ###
read -p "input server ip(xxx.xxx.xxx): " server_ip # 定义服务程序公网
read -p "input server port(7000): " server_port    # 定义服务程序公网
read -p "input flow port(6000): " flow_port        # 定义服务程序公网

toml_file_path="./frpc.toml" # 定义配置文件路径

if [ -f "$toml_file_path" ]; then # 生成新的配置文件
  rm -f "$toml_file_path"
  echo "The old toml file has been deleted: $toml_file_path."
fi
cat <<EOF >"$toml_file_path"
### @author <a href="https://github.com/xiaogithubooo">limou3434</a> ###
### @from <a href="https://xxx.com">xxx</a> ###

# 配置内网穿透
serverAddr = "$server_ip" # 公网机器
serverPort = $server_port # 请求端口

[[proxies]]
name = "frp-tcp"
type = "tcp"          # 协议类型
localIP = "127.0.0.1" # 转发地址
localPort = 22        # 转发端口
remotePort = $flow_port     # 公网流端
EOF
echo "The new toml file has been generated: $toml_file_path."

### 生成客户端服务文件 ###
script_dir=$(realpath $(dirname "$0")) # 定义服务工作目录

service_file_path="/etc/systemd/system/frpc.service" # 定义服务文件路径

if [ -f "$service_file_path" ]; then # 生成新的服务文件
  sudo systemctl stop frpc.service
  rm -f "$service_file_path"
  echo "The old service file has been deleted: $service_file_path."
fi
cat <<EOF >"$service_file_path"
### @author <a href="https://github.com/xiaogithubooo">limou3434</a> ###
### @from <a href="https://xxx.com">xxx</a> ###

[Unit]
# 服务名称
Description = frp client
# 启动条件
After=network.target

[Service]
# 服务类型
Type = simple
# 运行指令
ExecStart = $script_dir/frpc -c $script_dir/frpc.toml
# 异常重试
Restart=on-failure
RestartSec=5s

[Install]
# 自动重启
WantedBy = multi-user.target
EOF

echo "The service file has been generated: $service_file_path."

### 一键加载启用服务程序 ###
echo "Reloading systemd and enabling the service..."
sudo chmod +x $script_dir/frpc
sudo systemctl daemon-reload
sudo systemctl enable frpc.service
sudo systemctl start frpc.service
sudo ufw allow $server_port

echo "successful: The work-Intranet-penetration service is runing..."


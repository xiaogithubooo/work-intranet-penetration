#!/bin/bash
### @author <a href="https://github.com/xiaogithubooo">limou3434</a> ###
### @from <a href="https://xxx.com">xxx</a> ###

### 生成服务端配置文件 ###
# 获取服务运行端口
read -p "input bind port(7000): " bind_port
# bind_port=${bind_port:-7000}

# 获取服务工作名称
read -p "input bind name(frps): " bind_name
# bind_name=${bind_name:-frps}

# 获取控制界面地址
read -p "input control web ip(0.0.0.0): " control_web_ip
# control_web_ip=${control_web_ip:0.0.0.0}

# 获取控制界面端口
read -p "input control web port(7500): " control_web_port
control_web_port=${control_web_port:-7500}

# 获取控制界面密用户
read -p "input control web name(admin):" control_web_name
# control_web_name=${control_web_name:-admin}

# 获取控制界面密码
read -sp "input control web password(123456): " control_web_password
echo
# control_web_password=${control_web_password:-123456}

# 获取服务运行端口
read -p "input flow port(6000): " flow_port
# flow_port=${flow_port:-6000}

# 生成新的配置文件
toml_file="./$bind_name.toml"
if [ -f "$toml_file" ]; then
  rm -f "$toml_file"
  echo "The old toml file has been deleted: $toml_file."
fi
cat <<EOF >"$toml_file"
### @author <a href="https://github.com/xiaogithubooo">limou3434</a> ###
### @from <a href="https://xxx.com">xxx</a> ###

# 配置内网穿透
bindPort = $bind_port # 服务端监听端口

# 配置控制台
webServer.addr = "$control_web_ip"              # 控制台监听地址
webServer.port = $control_web_port              # 控制台监听端口
webServer.user = "$control_web_name"            # 控制台用户名称
webServer.password = "$control_web_password"    # 控制台用户密码
EOF
echo "The new toml file has been generated: $toml_file."

### 生成服务端服务文件 ###
script_dir=$(realpath $(dirname "$0"))                     # 定义服务工作路径
service_file_path="/etc/systemd/system/$bind_name.service" # 定义服务文件路径

if [ -f "$service_file_path" ]; then # 生成新的服务文件
  sudo systemctl stop frps.service
  rm -f "$service_file_path"
  echo "The old service file has been deleted: $service_file_path."
fi
sudo cat <<EOF >"$service_file_path"
### @author <a href="https://github.com/xiaogithubooo">limou3434</a> ###
### @from <a href="https://xxx.com">xxx</a> ###

[Unit]
# 服务名称
Description = $bind_name
# 启动条件
After=network.target

[Service]
# 服务类型
Type = simple
# 运行指令
ExecStart = $script_dir/frps -c $script_dir/$bind_name.toml
# 异常重试
Restart=on-failure
RestartSec=5s

[Install]
# 自动重启
WantedBy = multi-user.target
EOF

echo "The service file has been generated: $service_file_path."

### 一键加载启用服务程序 ###
echo "Reloading systemd and enabling the $bind_name service..."
sudo chmod +x $script_dir/frps
sudo systemctl daemon-reload
sudo systemctl enable $bind_name.service
sudo systemctl start $bind_name.service
sudo ufw allow $bind_port
sudo ufw allow $flow_port
sudo ufw allow $control_web_port

echo "successful: The work-intranet-penetration "$bind_name".service is runing..."

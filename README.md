# 工作室自动穿透程序

## 程序概要

工作室需要有一个程序，可以快速穿透内网 `Ubuntu` 服务器，并且有方便的管理控制台，避免重复配置穿透功能。

## 安装软件

```shell
# 安装软件
git clone https://github.com/xiaogithubooo/work-intranet-penetration
```

## 使用方法

```shell
# 服务端使用方法
sudo bash work-intranet-penetration/frps/frps_install.bash && \
sudo bash work-intranet-penetration/frps/frps_run.bash
# 根据提示进行配置...
```

```shell
# 客户端使用方法
sudo bash work-intranet-penetration/frpc/frpc_install.bash && \
sudo bash work-intranet-penetration/frpc/frpc_run.bash
# 根据提示进行配置...
```

## 注意事项

1. 该项目正处于开发阶段，暂时只提供最为初级便捷的核心功能
2. 如果您使用的是云服务器，需要开放运行服务端时所填写的所有端口
3. 本项目基于 `frp` 开发，感谢该项目的所有开发者


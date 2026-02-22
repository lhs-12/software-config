#!/bin/sh
# 添加~/.local/bin到PATH环境变量
# 不能在environment.d中设置, PATH会被桌面环境覆盖, 改用KDE预启动脚本
export PATH="$HOME/.local/bin:$PATH"
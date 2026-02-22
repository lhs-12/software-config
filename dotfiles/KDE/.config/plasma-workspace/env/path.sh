#!/bin/sh
# 添加~/.local/bin到PATH环境变量
# 不能在environment.d中设置, PATH会被桌面环境覆盖, 改用KDE预启动脚本
append_path(){ case ":$PATH:" in *:"$1":*) ;; *) PATH="${PATH:+$PATH:}$1" ;; esac; }
append_path "$HOME/.local/bin"

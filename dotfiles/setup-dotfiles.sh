#!/bin/bash

# ===============================================================
# GNU Stow 配置文件同步工具
# ===============================================================
# 【功能说明】
# 01. 使用 GNU Stow 将 dotfiles 仓库中的配置文件同步到用户目录
# 02. 使用 stow --adopt 模式: 将系统现有文件拉取到仓库并建立软链接
# 03. 支持配置文件分组管理 (FOLD / NO_FOLD)
# 04. 支持多级目录包名 (如 WSL-Arch/Bash, a/b/c)
# 05. 支持 --auto 模式: 自动确认, 无需用户交互
# 06. 支持 FOLD / NO_FOLD 两种模式, 详见下方 [模式说明]
# 07. 执行前预览 (dry-run), 确认后再实际应用
# ===============================================================
# 【命令行参数】
# <config_file>               配置文件路径 (必需)
# --auto                      自动确认所有包, 无需用户交互
# --help, -h                  显示帮助信息
# ===============================================================
# 【配置文件格式】
# [NO_FOLD]                   NO_FOLD 模式的包列表
# [FOLD]                      FOLD 模式的包列表
# 注: 一行可放多个包名, 用空格分隔, 包名不得包含空格
# ===============================================================
# 【使用示例】
# ./setup-dotfiles.sh dotfiles.conf          # 交互式确认每个包
# ./setup-dotfiles.sh dotfiles.conf --auto   # 自动应用所有包
# ===============================================================
# 【取消配置】
# stow -D -t "$HOME" <package>               # 取消指定包的软链接
# stow -D -d <dir> -t "$HOME" <package>      # 取消多级目录包的软链接
# ===============================================================
# 【模式说明】
# FOLD / NO_FOLD 有两个层面的含义:
# 1. Stow 官方行为(tree folding):
#    FOLD (默认模式): 当条件满足时 Stow 可能将整个目录折叠为目录软链接
#    NO_FOLD (--no-folding): 尽量保持目录结构避免折叠, 每个文件单独建立软链接
# 2. 本脚本的设计意图:
#    FOLD: 适用于目标目录主要由仓库管理, 或文件所在目录已存在, 不会纳入无关文件的场景
#    NO_FOLD: 适用于目录中存在非托管文件(如软件自动生成文件, 本地私有配置等), 需要避免整个目录被折叠为目录软链接的场景
# ===============================================================
# 【注意事项】
# 本脚本使用 stow --adopt
# 执行时若目标位置已存在同名文件, Stow 会将该文件移动到仓库中, 并在原位置创建软链接
# 首次运行前请确认仓库已纳入版本控制, 并建议提前备份重要配置文件
# ===============================================================

set -Eeuo pipefail

# 从配置文件中提取包列表
get_list() { sed -n "/^\[$1\]/,/^\[/p" "$conf" | grep -v '^\[' | sed 's/#.*//' | xargs || :; }

stow_packages() {
    local extra_flags=$1; shift
    local pkgs=("$@")
    for pkg in "${pkgs[@]}"; do
        echo "=== Package: $pkg ==="
        # 处理带斜杠的包名
        # 将 "WSL-Arch/Bash" 拆分为 stow_dir="WSL-Arch", pkg_name="Bash"
        # 使用 stow -d WSL-Arch Bash 来避免斜杠问题
        local stow_dir="."
        local pkg_name="$pkg"
        if [[ "$pkg" == */* ]]; then
            stow_dir="${pkg%/*}"
            pkg_name="${pkg##*/}"
        fi
        # 预览模式: 先 dry-run 显示会执行的操作
        stow $extra_flags --adopt -d "$stow_dir" -n -v -t "$HOME" "$pkg_name" 2>&1 |
            grep -v 'WARNING: in simulation mode so not modifying filesystem.' >&2 || true
        # 确认并执行
        local apply=; $auto && apply=y || read -rp "Apply this package? [y/n] " apply
        [[ $apply == [yY] ]] && stow $extra_flags --adopt -d "$stow_dir" -t "$HOME" "$pkg_name" || echo "Skipped $pkg"
    done
}

# 校验参数
[[ $# -lt 1 ]] && echo "Usage: $0 <config_file> [--auto]" && exit 1
conf=""; auto=false
for arg in "$@"; do
    if [[ "$arg" == "--auto" ]]; then auto=true
    elif [[ -f "$arg" ]]; then [[ -z "$conf" ]] && conf="$(realpath "$arg")" || { echo "Error: Multiple files detected"; exit 1; }
    else echo "Error: Invalid argument '$arg'"; exit 1; fi
done
[[ -z "$conf" ]] && { echo "Error: Config file not found"; exit 1; }

# 切换到 dotfiles 目录
cd "$(dirname "$0")"
# 提取清单
FOLD_PACKAGES=($(get_list "FOLD"))
NO_FOLD_PACKAGES=($(get_list "NO_FOLD"))
# 同步配置
[[ ${#NO_FOLD_PACKAGES[@]} -gt 0 ]] && {
    echo "====== Stowing no-folding configs ======"
    stow_packages "--no-folding" "${NO_FOLD_PACKAGES[@]}"
}
[[ ${#FOLD_PACKAGES[@]} -gt 0 ]] && {
    echo "====== Stowing folding configs ======"
    stow_packages "" "${FOLD_PACKAGES[@]}"
}
echo -e "\nDone."
exit 0

#!/bin/bash
set -Eeuo pipefail

get_list() { sed -n "/^\[$1\]/,/^\[/p" "$conf" | grep -v '^\[' | sed 's/#.*//' | xargs || :; }

stow_packages() {
    local extra_flags=$1; shift
    local pkgs=("$@")
    for pkg in "${pkgs[@]}"; do
        echo "=== Package: $pkg ==="
        stow $extra_flags --adopt -n -v -t "$HOME" "$pkg" 2>&1 |
            grep -v 'WARNING: in simulation mode so not modifying filesystem.' >&2 || true
        local apply=; $auto && apply=y || read -rp "Apply this package? [y/n] " apply
        [[ $apply == [yY] ]] && stow $extra_flags --adopt -t "$HOME" "$pkg" || echo "Skipped $pkg"
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
# 切换到dotfiles目录
cd "$(dirname "$0")"
# 提取清单
FOLD_PACKAGES=($(get_list "FOLD"))
NO_FOLD_PACKAGES=($(get_list "NO_FOLD"))
# 同步配置
[[ ${#FOLD_PACKAGES[@]} -gt 0 ]] && {
    echo "====== Stowing folding configs ======"
    stow_packages "" "${FOLD_PACKAGES[@]}"
}
[[ ${#NO_FOLD_PACKAGES[@]} -gt 0 ]] && {
    echo "====== Stowing no-folding configs ======"
    stow_packages "--no-folding" "${NO_FOLD_PACKAGES[@]}"
}
echo -e "\nDone."
exit 0

# 取消配置: stow -D -t "$HOME" pkg , 记得先加-n -v调试
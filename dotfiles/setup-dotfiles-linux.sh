#!/bin/bash
set -Eeuo pipefail
cd "$(dirname "$0")"

FOLD_PACKAGES=(
    "Bash" "Fish" "OhMyPosh" "Yazi" "WezTerm" "Kitty" "Pictures" "FontConfig" "Fcitx5"
    "LazyVim" "Mise" "Ruff" "Jetbrains" "Flameshot" "MPV" "Btop"
)

NO_FOLD_PACKAGES=(
    "KDE" "Rime" "VSCode" "Xremap" "MyScripts"
)

auto=false; [[ ${1:-} == --auto ]] && auto=true # --auto : apply all packages without prompting

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

echo "====== Stowing folding configs ======"
stow_packages "" "${FOLD_PACKAGES[@]}"

echo "====== Stowing no-folding configs ======"
stow_packages "--no-folding" "${NO_FOLD_PACKAGES[@]}"

echo -e "\nDone."
exit 0

#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

FOLD_GROUP=(
    "Bash" "Pictures" "OhMyPosh" "Yazi" "WezTerm" "FontConfig" "Fcitx5" "Flameshot"
    "LazyVim" "Mise" "Ruff" "Jetbrains"
)

NO_FOLD_GROUP=(
    "KDE" "Rime" "VSCode" "Xremap"
)

auto=false; [[ ${1:-} == --auto ]] && auto=true # --auto : apply all packages without prompting

echo "====== Stowing folding configs ======"
for pkg in "${FOLD_GROUP[@]}"; do
    echo "=== Package: $pkg ==="
    stow --adopt -n -v -t "$HOME" "$pkg" 2>&1 |
        grep -v 'WARNING: in simulation mode so not modifying filesystem.' >&2 || true
    apply=; $auto && apply=y || read -rp "Apply this package? [y/n] " apply
    [[ $apply == [yY] ]] && stow --adopt -t "$HOME" "$pkg" || echo "Skipped $pkg"
done

echo "====== Stowing no-folding configs ======"
for pkg in "${NO_FOLD_GROUP[@]}"; do
    echo "=== Package: $pkg ==="
    stow --no-folding --adopt -n -v -t "$HOME" "$pkg" 2>&1 |
        grep -v 'WARNING: in simulation mode so not modifying filesystem.' >&2 || true
    apply=; $auto && apply=y || read -rp "Apply this package? [y/n] " apply
    [[ $apply == [yY] ]] && stow --no-folding --adopt -t "$HOME" "$pkg" || echo "Skipped $pkg"
done

echo -e "\nDone."
exit 0

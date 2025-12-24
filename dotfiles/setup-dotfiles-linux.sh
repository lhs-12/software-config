#!/bin/bash
cd "$(dirname "$0")"

FOLD_GROUP=(
    "Bash" "OhMyPosh" "Yazi" "WezTerm" "FontConfig" "Fcitx5" "Flameshot"
    "LazyVim" "Mise" "Ruff" "Jetbrains"
)

NO_FOLD_GROUP=(
    "KDE" "Pictures" "Rime" "VSCode" "Xremap"
)

[[ $1 == --auto ]] && ans=y || ans= # --auto : apply all packages without prompting

echo "====== Stowing folding configs ======"
for pkg in "${FOLD_GROUP[@]}"; do
    echo "=== Package: $pkg ==="
    stow --adopt -n -v -t "$HOME" "$pkg" 2>&1 |
    grep -v 'WARNING: in simulation mode so not modifying filesystem.' >&2
    [[ -z $ans ]] && read -rp "Apply this package? [y/n] " ans
    [[ $ans == [yY] ]] && stow --adopt -t "$HOME" "$pkg" || echo "Skipped $pkg"
done

echo "====== Stowing no-folding configs ======"
for pkg in "${NO_FOLD_GROUP[@]}"; do
    echo "=== Package: $pkg ==="
    stow --no-folding --adopt -n -v -t "$HOME" "$pkg" 2>&1 |
    grep -v 'WARNING: in simulation mode so not modifying filesystem.' >&2
    [[ -z $ans ]] && read -rp "Apply this package? [y/n] " ans
    [[ $ans == [yY] ]] && stow --no-folding --adopt -t "$HOME" "$pkg" || echo "Skipped $pkg"
done

echo -e "\nDone."
exit 0
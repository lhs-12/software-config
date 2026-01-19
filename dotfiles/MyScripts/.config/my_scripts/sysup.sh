#!/bin/bash

# ==============================================================================
# sysup - Arch Linux update helper (Arch News + Update)
# Features:
#   - Fetch Arch news in different languages
#   - Highlight "manual intervention" warnings
#   - Then run yay / paru
#
# Options:
#   --count N    Maximum number of news items to display
#   --lang zh|en Specify language
# ==============================================================================

# ------------------------------
# 1. Default parameters
# ------------------------------
COUNT_LIMIT=15
LANG_MODE="en"
# LANG_MODE=$(locale 2>/dev/null | grep -q "zh_CN" && echo zh || echo en) # follow system locale

# ------------------------------
# 2. Argument parsing (GNU-style)
# ------------------------------
while [ $# -gt 0 ]; do
    case "$1" in
        --count)
            COUNT_LIMIT="$2"
            shift 2
            ;;
        --lang)
            LANG_MODE="$2"
            shift 2
            ;;
        *)
            printf "Unknown option: %s\nUsage: sysup [--count N] [--lang zh|en]\n" "$1"
            exit 1
    esac
done

# ------------------------------
# 3. Detect AUR helper
# ------------------------------
UPDATE_CMD=""
if command -v paru >/dev/null 2>&1; then
    UPDATE_CMD="paru"
elif command -v yay >/dev/null 2>&1; then
    UPDATE_CMD="yay"
else
    printf "\n\033[1;31m!!! Error: No AUR helper found (yay/paru) !!!\033[0m\n"
    exit 1
fi

# ------------------------------
# 4. Localized strings
# ------------------------------
if [ "$LANG_MODE" = "zh" ]; then
    NEWS_URL="https://www.archlinuxcn.org/category/news/feed/"
    MSG_PREPARING="==> 准备使用 $UPDATE_CMD 更新系统..."
    MSG_FETCHING="==> 正在获取 Arch Linux 中文社区最新新闻..."
    MSG_CONFIRM="请确认无重大问题。是否继续执行 $UPDATE_CMD? [Y/n] "
    MSG_EXECUTING="==> 执行 $UPDATE_CMD 更新..."
    MSG_CANCEL="==> 更新已取消。"
    MSG_ERR_FETCH="!!! 警告: 无法获取新闻 (可能是网络或源的问题) !!!"
    MSG_FORCE_ASK="是否**强制**忽略新闻并继续更新? [y/N] "
    MSG_FORCING="==> 正在强制更新..."
    MSG_EXIT="==> 安全退出。"
    PY_HEADER=">>> 最近 {} 条 Arch 中文新闻:"
else
    NEWS_URL="https://archlinux.org/feeds/news/"
    MSG_PREPARING="==> Preparing to update system with $UPDATE_CMD..."
    MSG_FETCHING="==> Fetching latest Arch Linux news..."
    MSG_CONFIRM="Read above. Proceed with $UPDATE_CMD? [Y/n] "
    MSG_EXECUTING="==> Executing $UPDATE_CMD..."
    MSG_CANCEL="==> Update cancelled."
    MSG_ERR_FETCH="!!! WARNING: Failed to fetch news (Network/Source error) !!!"
    MSG_FORCE_ASK="Force update ignoring news? [y/N] "
    MSG_FORCING="==> Forcing update..."
    MSG_EXIT="==> Safe exit."
    PY_HEADER=">>> Recent {} Arch Linux news items:"
fi

# ------------------------------
# 5. Main execution logic
# ------------------------------
printf "\n\033[1;36m%s\033[0m\n" "$MSG_PREPARING"
printf "\033[1;36m%s\033[0m\n" "$MSG_FETCHING"

PYTHON_SCRIPT=$(cat <<'EOF'
import sys
import xml.etree.ElementTree as ET

try:
    limit = int(sys.argv[1])
    header_template = sys.argv[2]

    sys.stdin.reconfigure(encoding='utf-8')
    raw_data = sys.stdin.read()

    if not raw_data.strip():
        sys.exit(1)

    root = ET.fromstring(raw_data)
    items = root.findall('./channel/item')[:limit]

    print(f'\n\033[1;33m{header_template.format(len(items))}\033[0m\n')

    for item in items:
        title = item.find('title').text
        pub_date = item.find('pubDate').text
        date_str = pub_date[:16]

        check_text = title.lower()
        # Highlight keywords related to manual intervention
        if any(x in check_text for x in ['intervention', 'manual', '手动干预', '干预']):
            color = '\033[1;31m' # Red
            prefix = '!!! '
        else:
            color = '\033[1;32m' # Green
            prefix = ''

        print(f'{color}[{date_str}] {prefix}{title}\033[0m')

except Exception as e:
    sys.stderr.write(f'\nParse Error: {e}\n')
    sys.exit(1)
EOF
)

# Fetch news and pipe to python for processing
if curl -sS -L --connect-timeout 15 -A "Mozilla/5.0" "$NEWS_URL" \
    | python -c "$PYTHON_SCRIPT" "$COUNT_LIMIT" "$PY_HEADER";
then
    # News fetched successfully

    printf "\n%s" "$MSG_CONFIRM"
    read -r confirm

    case "$confirm" in
        [Yy]*|"" )
            printf "\n\033[1;34m==> Checking/Updating keyrings first...\033[0m\n"
            KEYRING_TARGETS="archlinux-keyring"
            # Only include archlinuxcn-keyring if it is installed
            if pacman -Qq archlinuxcn-keyring >/dev/null 2>&1; then
                KEYRING_TARGETS="$KEYRING_TARGETS archlinuxcn-keyring"
            fi
            # Sync package databases and update keyring packages if needed
            if sudo pacman -Sy --needed --noconfirm $KEYRING_TARGETS; then
                printf "\033[1;32m==> Keyrings verified.\033[0m\n"
            else
                printf "\033[1;31m!!! Warning: Keyring update encountered issues. Proceeding...\033[0m\n"
            fi
            printf "\n\033[1;36m%s\033[0m\n" "$MSG_EXECUTING"
            $UPDATE_CMD
            ;;
        * )
            printf "\n\033[1;33m%s\033[0m\n" "$MSG_CANCEL"
            exit 0
            ;;
    esac
else
    # Failed to fetch or parse news, ask whether to force update
    printf "\n\033[1;31m%s\033[0m\n" "$MSG_ERR_FETCH"

    printf "%s" "$MSG_FORCE_ASK"
    read -r force_confirm

    case "$force_confirm" in
        [Yy]* )
            printf "\n\033[1;34m==> Checking/Updating keyrings first...\033[0m\n"
            KEYRING_TARGETS="archlinux-keyring"
            if pacman -Qq archlinuxcn-keyring >/dev/null 2>&1; then
                KEYRING_TARGETS="$KEYRING_TARGETS archlinuxcn-keyring"
            fi
            if sudo pacman -Sy --needed --noconfirm $KEYRING_TARGETS; then
                printf "\033[1;32m==> Keyrings verified.\033[0m\n"
            else
                printf "\033[1;31m!!! Warning: Keyring update encountered issues. Proceeding...\033[0m\n"
            fi
            printf "\n\033[1;31m%s\033[0m\n" "$MSG_FORCING"
            $UPDATE_CMD
            ;;
        * )
            printf "\n\033[1;33m%s\033[0m\n" "$MSG_EXIT"
            exit 1
            ;;
    esac
fi

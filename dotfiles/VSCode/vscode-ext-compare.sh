#!/usr/bin/bash

# 比对 VSCode配置.md 中记录的扩展 和 实际安装扩展("code --list-extensions")

# VSCode 的 package.json:
# extensionPack: 方便地一次安装一堆扩展
# extensionDependencies: 扩展的运行时依赖

# 本脚本中"root扩展"的定义: 直接安装的拓展(没有出现在extensionPack中)

set -Eeuo pipefail
trap 'echo "ERROR at line $LINENO: $BASH_COMMAND" >&2' ERR
cd "$(dirname "$0")"

# ------------------------------------------------------------
# 依赖检查
# ------------------------------------------------------------
for cmd in code jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "缺少依赖命令: $cmd"
    exit 1
  fi
done

# ------------------------------------------------------------
# 获取 VSCode配置.md 中记录的扩展 (期望的 root 扩展)
# ------------------------------------------------------------
# 识别每行的第一个 --install-extension, 扩展 ID 紧随其后, 空格分隔
expected_roots=$(
  grep -E "^\s*--install-extension" VSCode配置.md \
    | sed -n 's/.*--install-extension \([^ ]*\).*/\1/p' \
    | sort -u
)

# ------------------------------------------------------------
# 获取所有实际安装的扩展
# ------------------------------------------------------------
if ! install_exts=$(code --list-extensions 2>/dev/null | sort -u); then
  echo "无法获取已安装扩展列表"
  exit 1
fi

# ------------------------------------------------------------
# 根据系统确定扩展目录路径
# ------------------------------------------------------------
if [[ "$OSTYPE" =~ (linux|gnu|darwin) ]]; then # Linux 或 macOS
  EXTS_DIR="$HOME/.vscode/extensions"
elif [[ "$OSTYPE" =~ (cygwin|msys|win32) ]]; then # Windows
  EXTS_DIR="${USERPROFILE:-$HOME}/.vscode/extensions"
else
  echo "警告: 无法检测操作系统"
  exit 1
fi
if [[ ! -d "$EXTS_DIR" ]]; then
  echo "找不到扩展目录: $EXTS_DIR"
  exit 1
fi

# ------------------------------------------------------------
# 扫描 extensionPack 和 extensionDependencies，构建扩展关系集合
#
# package.json语义:
# extensionPack: 一个包的聚合包集合, 正常来说里面都不是root包
# extensionDependencies: 包的运行依赖包, 里面可能有root包
# ------------------------------------------------------------
EXTS_JSON="$EXTS_DIR/extensions.json"
if [[ ! -f "$EXTS_JSON" ]]; then
  echo "找不到 extensions.json: $EXTS_JSON" >&2
  exit 1
fi

# 同时收集 non_root_exts (来自 extensionPack) 和 dependency_exts (来自 extensionDependencies)
# 注意：使用冒号作为分隔符 (PACK: 和 DEP:)，方便后续处理
combined_output=$(
  while IFS= read -r ext_id; do
    # 从 extensions.json 找到该扩展的当前生效目录
    ext_dir=$(jq -r --arg id "$ext_id" '
      [
        .[]
        | select(.identifier.id == $id)
        | select(.relativeLocation? != null)
      ]
      | ( map(select(.metadata.updated == true)) + . )
      | .[0].relativeLocation
    ' "$EXTS_JSON")
    # 检查扩展包相对路径
    if [[ -z "$ext_dir" || "$ext_dir" == "null" ]]; then
      echo "错误: extensions.json 中找不到扩展: $ext_id" >&2
      continue
    fi
    # 构建扩展包路径
    pkg_json="$EXTS_DIR/$ext_dir/package.json"
    if [[ ! -f "$pkg_json" ]]; then
      echo "警告: 找不到扩展包文件: $pkg_json" >&2
      continue
    fi

    # jq提取extensionPack | 小写转换 | 排除"自引用"的情况 | 过滤已安装 | 添加PACK前缀
    # 结尾 || true 防止-Eeuo pipefail报错
    jq -r '.extensionPack[]?' "$pkg_json" \
      | tr '[:upper:]' '[:lower:]' | grep -v -F -x "$ext_id" \
      | grep -F -x -f <(printf "%s\n" "$install_exts") \
      | sed 's/^/PACK:/' || true
    # jq提取extensionDependencies | 小写转换 | 排除"自引用"的情况 | 过滤已安装 | 添加DEP前缀以及源拓展id
    # 结尾 || true 防止-Eeuo pipefail报错
    jq -r '.extensionDependencies[]?' "$pkg_json" \
      | tr '[:upper:]' '[:lower:]' | grep -v -F -x "$ext_id" \
      | grep -F -x -f <(printf "%s\n" "$install_exts") \
      | sed "s/^/DEP:$ext_id:/" || true
  done <<< "$install_exts"
)

# 分离两类扩展，同时保存 dependency 的来源
non_root_exts=$(printf "%s\n" "$combined_output" | grep "^PACK:" | sed 's/^PACK://' | sort -u)
dependency_exts=$(printf "%s\n" "$combined_output" | grep "^DEP:" | sed 's/^DEP://' | sort -u)
# 保存依赖来源关系
declare -A dependency_sources
while read -r line; do
  # dependency_sources[扩展ID] = 来源扩展ID
  dependency_sources["${line#*:}"]="${line%:*}"
done <<< "$dependency_exts"
dependency_exts=$(printf "%s\n" "$dependency_exts" | sed 's/^[^:]*://') # 只保留扩展 ID

# ------------------------------------------------------------
# 比对结果
# ------------------------------------------------------------

# grep 参数:
# -v: 反向匹配 ; -F: 固定字符串匹配(非正则) ; -x: 整行匹配 ; -f: 从文件读取模式
# 示例: 获取新增行: grep -v -F -x -f old.txt new.txt ; 获取删除行: grep -v -F -x -f new.txt old.txt

# 特殊处理：过滤掉 github.copilot 和 github.copilot-chat（循环依赖）
# 这两个扩展互相在对方的 extensionPack 中，导致都被判定为 non-root
non_root_exts=$(printf "%s\n" "$non_root_exts" | grep -v -E '^(github\.copilot|github\.copilot-chat)$')

# root 扩展 (install_exts - non_root_exts)
root_installed=$(
  printf "%s\n" "$install_exts" | grep -v -F -x -f <(printf "%s\n" "$non_root_exts")
)
# 已安装, 文档未记录, root 扩展 (root_installed - expected_roots)
new_root_installed=$(
  printf "%s\n" "$root_installed" | grep -v -F -x -f <(printf "%s\n" "$expected_roots") || true
)
# 已安装, 文档未记录, 非依赖, root 扩展 (new_root_installed - dependency_exts)
printf "\n【新装扩展】已安装但文档未记录(建议添加到文档)\n"
printf "%s\n" "$new_root_installed" | grep -v -F -x -f <(printf "%s\n" "$dependency_exts") || true
# 已安装, 文档未记录, 来自依赖, root 扩展 (new_root_installed ∩ dependency_exts)
printf "\n【依赖扩展】已安装但文档未记录, 来自其他扩展的依赖\n"
while read -r ext_id; do
  # 补充拓展来源信息
  source="${dependency_sources[$ext_id]:-}"
  printf "%s ← 来自 %s\n" "$ext_id" "$source"
done < <(printf "%s\n" "$new_root_installed" | grep -F -x -f <(printf "%s\n" "$dependency_exts") || true)
# 未安装, 文档已记录, root 扩展 (expected_roots - root_installed)
printf "\n【缺失扩展】文档已记录但未安装(建议安装)\n"
printf "%s\n" "$expected_roots" | grep -v -F -x -f <(printf "%s\n" "$root_installed") || true
# 已安装, 文档已记录, 非 root 扩展 (expected_roots ∩ non_root_exts)
printf "\n【记录冗余】文档有记录但实际是某个已装扩展的子扩展(可从文档移除)\n"
printf "%s\n" "$expected_roots" | grep -F -x -f <(printf "%s\n" "$non_root_exts") || true
printf "\n"

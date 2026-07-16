#!/usr/bin/bash
# 全局安装 Agent Skills
# 用法: bash setup-agent-skills.sh
# 依赖: vercel-labs/skills CLI
# Eve 和 PromptScript 不支持全局安装, 会失败, 属于预期行为
set -Eeuo pipefail

# 目录映射:
#   --agent zed -> ~/.agents/skills/  (兼容 omp, snow ...)
#   --agent pi  -> ~/.pi/agent/skills/
AGENT_ARGS=()
agents() { AGENT_ARGS=(); for a in "$@"; do AGENT_ARGS+=(--agent "$a"); done; }
add_skills() {
  local repo="$1"; shift
  echo "Installing ${repo} ($*)..."
  skills add "$repo" -g "${AGENT_ARGS[@]}" "$@" -y
}

# === Base ===
agents pi zed
add_skills browser-act/skills -s browser-act -s browser-act-skill-forge
add_skills anthropics/skills -s docx -s xlsx -s pptx -s pdf
add_skills anthropics/skills -s doc-coauthoring

# === Development ===
agents zed
add_skills t8y2/dbx -s dbx
add_skills upstash/context7 -s context7-cli
add_skills anthropics/skills -s frontend-design
add_skills mattpocock/skills -s grill-me -s grill-with-docs
add_skills obra/superpowers --all

echo "Skills setup done."

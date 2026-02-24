#!/bin/bash
# ──────────────────────────────────────────────────────────────
# Flutter AI UI Skill — Installer
# Downloads only the essential skill files (no README, images, etc.)
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/SpeakQuery/flutter-ai-ui-skill/main/install.sh | bash -s -- --ai antigravity
#   curl -sSL https://raw.githubusercontent.com/SpeakQuery/flutter-ai-ui-skill/main/install.sh | bash -s -- --ai claude
#   curl -sSL https://raw.githubusercontent.com/SpeakQuery/flutter-ai-ui-skill/main/install.sh | bash -s -- --ai cursor
#   curl -sSL https://raw.githubusercontent.com/SpeakQuery/flutter-ai-ui-skill/main/install.sh | bash -s -- --ai all
#
# Or run locally:
#   bash install.sh --ai antigravity
# ──────────────────────────────────────────────────────────────

set -e

REPO="SpeakQuery/flutter-ai-ui-skill"
BRANCH="main"
SKILL_NAME="flutter-ai-ui-skill"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

# ── AI platform paths ─────────────────────────────────────────
declare -A AI_PATHS
AI_PATHS=(
  [antigravity]=".agents/skills/$SKILL_NAME"
  [claude]=".claude/skills/$SKILL_NAME"
  [cursor]=".cursor/skills/$SKILL_NAME"
  [windsurf]=".windsurf/skills/$SKILL_NAME"
  [copilot]=".github/skills/$SKILL_NAME"
  [gemini]="$SKILL_NAME"
  [kiro]=".kiro/skills/$SKILL_NAME"
  [roo]=".roo/skills/$SKILL_NAME"
  [continue]=".continue/skills/$SKILL_NAME"
  [opencode]="$SKILL_NAME"
  [zed]="$SKILL_NAME"
  [codex]="$SKILL_NAME"
  [trae]="$SKILL_NAME"
)

# ── Essential files only (no README, CHANGELOG, images, .github/) ──
ESSENTIAL_FILES=(
  "SKILL.md"
  "data/flutter_colors.csv"
  "data/flutter_typography.csv"
  "data/flutter_animations.csv"
  "data/flutter_components.csv"
  "data/stacks/flutter_guidelines.csv"
  "scripts/analyse_flutter_project.py"
  "scripts/search_guidelines.py"
  "scripts/create_flutter_project.py"
)

ESSENTIAL_DIRS=(
  "templates/material3"
  "templates/cupertino"
  "templates/adaptive"
)

# ── Parse args ─────────────────────────────────────────────────
AI_PLATFORM=""
INSTALL_DIR=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --ai)
      AI_PLATFORM="$2"
      shift 2
      ;;
    --dir)
      INSTALL_DIR="$2"
      shift 2
      ;;
    --help|-h)
      echo ""
      echo -e "${BOLD}Flutter AI UI Skill — Installer${NC}"
      echo ""
      echo "Usage:"
      echo "  bash install.sh --ai <platform>"
      echo ""
      echo "Platforms:"
      echo "  antigravity   → .agents/skills/"
      echo "  claude        → .claude/skills/"
      echo "  cursor        → .cursor/skills/"
      echo "  windsurf      → .windsurf/skills/"
      echo "  copilot       → .github/skills/"
      echo "  gemini        → project root"
      echo "  kiro          → .kiro/skills/"
      echo "  roo           → .roo/skills/"
      echo "  continue      → .continue/skills/"
      echo "  opencode      → project root"
      echo "  all           → installs for all platforms"
      echo ""
      echo "Options:"
      echo "  --dir <path>  Custom install directory"
      echo "  --help        Show this help"
      echo ""
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

if [ -z "$AI_PLATFORM" ]; then
  echo -e "${RED}Error: --ai <platform> is required${NC}"
  echo "Run with --help to see available platforms"
  exit 1
fi

# ── Download function ──────────────────────────────────────────
download_skill() {
  local target_dir="$1"

  echo -e "\n${BOLD}🎨 Flutter AI UI Skill — Installing${NC}"
  echo -e "   Target: ${CYAN}$target_dir${NC}\n"

  # Create directory
  mkdir -p "$target_dir"
  mkdir -p "$target_dir/data/stacks"
  mkdir -p "$target_dir/scripts"

  # Download essential files
  local base_url="https://raw.githubusercontent.com/$REPO/$BRANCH"
  local count=0
  local total=${#ESSENTIAL_FILES[@]}

  for file in "${ESSENTIAL_FILES[@]}"; do
    count=$((count + 1))
    local dir=$(dirname "$target_dir/$file")
    mkdir -p "$dir"

    echo -e "  [$count/$total] Downloading ${CYAN}$file${NC}..."
    if curl -sSfL "$base_url/$file" -o "$target_dir/$file" 2>/dev/null; then
      echo -e "         ${GREEN}✓${NC}"
    else
      echo -e "         ${RED}✗ Failed${NC}"
    fi
  done

  # Download template directories
  for template_dir in "${ESSENTIAL_DIRS[@]}"; do
    echo -e "  Downloading template ${CYAN}$template_dir${NC}..."
    mkdir -p "$target_dir/$template_dir/lib"

    curl -sSfL "$base_url/$template_dir/pubspec.yaml" -o "$target_dir/$template_dir/pubspec.yaml" 2>/dev/null
    curl -sSfL "$base_url/$template_dir/lib/main.dart" -o "$target_dir/$template_dir/lib/main.dart" 2>/dev/null
    echo -e "         ${GREEN}✓${NC}"
  done

  echo -e "\n${GREEN}${BOLD}✅ Installation complete!${NC}"
  echo -e "   Installed to: ${CYAN}$target_dir${NC}"
  echo -e "   Files: ${CYAN}SKILL.md + 5 data CSVs + 3 scripts + 3 templates${NC}\n"
}

# ── Install ────────────────────────────────────────────────────
if [ "$AI_PLATFORM" = "all" ]; then
  echo -e "${BOLD}Installing for all platforms...${NC}"
  for platform in antigravity claude cursor windsurf copilot gemini; do
    target="${AI_PATHS[$platform]}"
    if [ -n "$target" ]; then
      download_skill "$target"
    fi
  done
elif [ -n "$INSTALL_DIR" ]; then
  download_skill "$INSTALL_DIR"
elif [ -n "${AI_PATHS[$AI_PLATFORM]}" ]; then
  download_skill "${AI_PATHS[$AI_PLATFORM]}"
else
  echo -e "${RED}Unknown platform: $AI_PLATFORM${NC}"
  echo "Run with --help to see available platforms"
  exit 1
fi

echo -e "${YELLOW}💡 Tip: Run 'bash install.sh --ai <platform>' again anytime to update.${NC}\n"

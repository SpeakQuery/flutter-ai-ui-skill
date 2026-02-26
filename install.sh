#!/bin/sh
# ──────────────────────────────────────────────────────────────
# Flutter AI UI Skill — Lightweight Installer
# Downloads only essential skill files (no README, images, docs)
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/SpeakQuery/flutter-ai-ui-skill/main/install.sh | sh -s -- --ai antigravity
# ──────────────────────────────────────────────────────────────

REPO="SpeakQuery/flutter-ai-ui-skill"
BRANCH="main"
SKILL_NAME="flutter-ai-ui-skill"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"

# ── Parse args ─────────────────────────────────────────────────
AI_PLATFORM=""

while [ $# -gt 0 ]; do
  case "$1" in
    --ai)
      AI_PLATFORM="$2"
      shift 2
      ;;
    --help|-h)
      printf "\n  Flutter AI UI Skill — Installer\n\n"
      printf "  Usage: curl -sSL ...install.sh | sh -s -- --ai <platform>\n\n"
      printf "  Platforms:\n"
      printf "    antigravity   .agents/skills/\n"
      printf "    claude        .claude/skills/\n"
      printf "    cursor        .cursor/skills/\n"
      printf "    windsurf      .windsurf/skills/\n"
      printf "    copilot       .github/skills/\n"
      printf "    gemini        project root\n"
      printf "    kiro          .kiro/skills/\n"
      printf "    roo           .roo/skills/\n"
      printf "    continue      .continue/skills/\n"
      printf "\n"
      exit 0
      ;;
    *)
      printf "Unknown option: %s\n" "$1"
      exit 1
      ;;
  esac
done

if [ -z "$AI_PLATFORM" ]; then
  printf "Error: --ai <platform> is required\n"
  printf "Run with --help to see available platforms\n"
  exit 1
fi

# ── Resolve install path (no associative arrays — POSIX compatible) ──
get_install_path() {
  case "$1" in
    antigravity) echo ".agents/skills/$SKILL_NAME" ;;
    claude)      echo ".claude/skills/$SKILL_NAME" ;;
    cursor)      echo ".cursor/skills/$SKILL_NAME" ;;
    windsurf)    echo ".windsurf/skills/$SKILL_NAME" ;;
    copilot)     echo ".github/skills/$SKILL_NAME" ;;
    gemini)      echo "$SKILL_NAME" ;;
    kiro)        echo ".kiro/skills/$SKILL_NAME" ;;
    roo)         echo ".roo/skills/$SKILL_NAME" ;;
    continue)    echo ".continue/skills/$SKILL_NAME" ;;
    opencode)    echo "$SKILL_NAME" ;;
    zed)         echo "$SKILL_NAME" ;;
    codex)       echo "$SKILL_NAME" ;;
    trae)        echo "$SKILL_NAME" ;;
    *)           echo "" ;;
  esac
}

# ── Download a single file ──────────────────────────────────────
download_file() {
  local_target="$1"
  remote_path="$2"
  dir_name=$(dirname "$local_target")
  mkdir -p "$dir_name"

  if curl -sSfL "$BASE_URL/$remote_path" -o "$local_target" 2>/dev/null; then
    printf "  ✓ %s\n" "$remote_path"
  else
    printf "  ✗ %s (failed)\n" "$remote_path"
  fi
}

# ── Install skill ──────────────────────────────────────────────
install_skill() {
  target_dir="$1"

  printf "\n🎨 Flutter AI UI Skill — Installing\n"
  printf "   Target: %s\n\n" "$target_dir"

  # Core
  download_file "$target_dir/SKILL.md" "SKILL.md"

  # Data
  download_file "$target_dir/data/flutter_colors.csv" "data/flutter_colors.csv"
  download_file "$target_dir/data/flutter_typography.csv" "data/flutter_typography.csv"
  download_file "$target_dir/data/flutter_animations.csv" "data/flutter_animations.csv"
  download_file "$target_dir/data/flutter_components.csv" "data/flutter_components.csv"
  download_file "$target_dir/data/stacks/flutter_guidelines.csv" "data/stacks/flutter_guidelines.csv"

  # Scripts
  download_file "$target_dir/scripts/analyse_flutter_project.py" "scripts/analyse_flutter_project.py"
  download_file "$target_dir/scripts/search_guidelines.py" "scripts/search_guidelines.py"
  download_file "$target_dir/scripts/create_flutter_project.py" "scripts/create_flutter_project.py"

  # Templates
  download_file "$target_dir/templates/material3/pubspec.yaml" "templates/material3/pubspec.yaml"
  download_file "$target_dir/templates/material3/lib/main.dart" "templates/material3/lib/main.dart"
  download_file "$target_dir/templates/cupertino/pubspec.yaml" "templates/cupertino/pubspec.yaml"
  download_file "$target_dir/templates/cupertino/lib/main.dart" "templates/cupertino/lib/main.dart"
  download_file "$target_dir/templates/adaptive/pubspec.yaml" "templates/adaptive/pubspec.yaml"
  download_file "$target_dir/templates/adaptive/lib/main.dart" "templates/adaptive/lib/main.dart"

  printf "\n✅ Installation complete!\n"
  printf "   Location : %s\n" "$target_dir"
  printf "   Files    : SKILL.md + 5 CSVs + 3 scripts + 3 templates\n\n"
}

# ── Run ────────────────────────────────────────────────────────
if [ "$AI_PLATFORM" = "all" ]; then
  printf "Installing for all platforms...\n"
  for p in antigravity claude cursor windsurf copilot gemini; do
    path=$(get_install_path "$p")
    install_skill "$path"
  done
else
  path=$(get_install_path "$AI_PLATFORM")
  if [ -z "$path" ]; then
    printf "Unknown platform: %s\n" "$AI_PLATFORM"
    printf "Run with --help to see available platforms\n"
    exit 1
  fi
  install_skill "$path"
fi

printf "💡 Re-run this command anytime to update to the latest version.\n\n"

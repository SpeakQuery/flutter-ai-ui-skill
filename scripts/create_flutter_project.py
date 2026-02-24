#!/usr/bin/env python3
"""
Flutter AI UI — Project Scaffolder
Creates a new Flutter project from the skill's templates.

Usage:
    python create_flutter_project.py --name my_app --template material3
    python create_flutter_project.py --name my_app --template cupertino --output ~/projects
    python create_flutter_project.py --name my_app --template adaptive
    python create_flutter_project.py --list-templates
"""

import os
import re
import sys
import shutil
import argparse
from pathlib import Path

# ─── ANSI Colors ──────────────────────────────────────────────────────────────
BOLD  = "\033[1m"
RED   = "\033[91m"
GREEN = "\033[92m"
CYAN  = "\033[96m"
YELLOW= "\033[93m"
RESET = "\033[0m"

def bold(s):   return f"{BOLD}{s}{RESET}"
def green(s):  return f"{GREEN}{s}{RESET}"
def red(s):    return f"{RED}{s}{RESET}"
def cyan(s):   return f"{CYAN}{s}{RESET}"
def yellow(s): return f"{YELLOW}{s}{RESET}"

SCRIPT_DIR    = Path(__file__).parent
TEMPLATES_DIR = SCRIPT_DIR.parent / "templates"

# ─── Templates ────────────────────────────────────────────────────────────────
TEMPLATES = {
    "material3": {
        "name":        "Material 3",
        "description": "Material 3 starter with GoRouter, Riverpod, GoogleFonts and dark mode",
        "tags":        ["M3", "GoRouter", "Riverpod", "GoogleFonts", "DarkMode"],
    },
    "cupertino": {
        "name":        "Cupertino (iOS Native)",
        "description": "iOS-native Cupertino design with CupertinoTabScaffold and CupertinoListSection",
        "tags":        ["iOS", "Cupertino", "Riverpod"],
    },
    "adaptive": {
        "name":        "Adaptive Multi-Platform",
        "description": "Adaptive layout for mobile (BottomNav), tablet (Rail) and desktop (Drawer)",
        "tags":        ["Mobile", "Tablet", "Desktop", "Web", "GoRouter", "Riverpod"],
    },
}


def list_templates():
    print(f"\n{bold('🎨 Flutter AI UI — Available Templates')}")
    print(f"{'─' * 50}\n")
    for key, t in TEMPLATES.items():
        tags = "  ".join(f"[{tag}]" for tag in t["tags"])
        print(f"  {bold(key)}")
        print(f"    {t['description']}")
        print(f"    {cyan(tags)}")
        print()
    print(f"  Usage: python create_flutter_project.py --name my_app --template material3\n")


def validate_project_name(name: str) -> bool:
    """Flutter project names must be lowercase with underscores."""
    return bool(re.match(r'^[a-z][a-z0-9_]*$', name))


def copy_template(template_key: str, project_name: str, output_dir: Path):
    template_src = TEMPLATES_DIR / template_key
    if not template_src.exists():
        print(red(f"ERROR: Template '{template_key}' not found at {template_src}"))
        sys.exit(1)

    dest = output_dir / project_name
    if dest.exists():
        print(red(f"ERROR: Directory '{dest}' already exists."))
        sys.exit(1)

    print(f"\n{bold('🚀 Creating Flutter project...')}")
    print(f"  Template : {cyan(template_key)} ({TEMPLATES[template_key]['name']})")
    print(f"  Name     : {cyan(project_name)}")
    print(f"  Location : {cyan(str(dest))}\n")

    # Copy template
    shutil.copytree(template_src, dest)

    # Update project name in pubspec.yaml
    pubspec = dest / "pubspec.yaml"
    if pubspec.exists():
        content = pubspec.read_text()
        # Replace template name with project name
        for old_name in ["flutter_material3_starter", "flutter_cupertino_starter", "flutter_adaptive_starter"]:
            content = content.replace(old_name, project_name)
        pubspec.write_text(content)

    # Update app title in main.dart
    main_dart = dest / "lib" / "main.dart"
    if main_dart.exists():
        content = main_dart.read_text()
        # Replace title strings
        for old_title in ["Flutter M3 App", "Flutter Cupertino Starter", "Flutter Adaptive Starter"]:
            content = content.replace(old_title, project_name.replace("_", " ").title())
        main_dart.write_text(content)

    print(green("✅ Project created successfully!\n"))
    print(f"{bold('Next steps:')}")
    print(f"  {cyan(f'cd {project_name}')}")
    print(f"  {cyan('flutter pub get')}")
    print(f"  {cyan('flutter run')}")
    print()
    print(f"{bold('Recommended packages to consider:')}")
    if template_key == "material3":
        print(f"  {yellow('flutter pub add shimmer')}          # Loading states")
        print(f"  {yellow('flutter pub add flutter_svg')}      # SVG icons")
        print(f"  {yellow('flutter pub add lottie')}           # Lottie animations")
    elif template_key == "cupertino":
        print(f"  {yellow('flutter pub add shimmer')}          # Loading shimmer")
    elif template_key == "adaptive":
        print(f"  {yellow('flutter pub add responsive_framework')} # Advanced breakpoints")

    print(f"\n  {bold('📖 Skill guidelines:')} python ../flutter-ai-ui-skill/scripts/search_guidelines.py --category widgets")
    print(f"  {bold('🔍 Audit your project:')} python ../flutter-ai-ui-skill/scripts/analyse_flutter_project.py --path .\n")


def main():
    parser = argparse.ArgumentParser(
        description="Flutter AI UI — Project Scaffolder"
    )
    parser.add_argument("--name",     "-n", help="Project name (lowercase, underscores allowed)")
    parser.add_argument("--template", "-t", help="Template to use: material3, cupertino, adaptive",
                        choices=list(TEMPLATES.keys()))
    parser.add_argument("--output",   "-o", help="Output directory (default: current directory)", default=".")
    parser.add_argument("--list-templates", "-l", action="store_true", help="List all available templates")
    args = parser.parse_args()

    if args.list_templates:
        list_templates()
        return

    if not args.name:
        print(red("ERROR: --name is required. Example: --name my_flutter_app"))
        parser.print_help()
        sys.exit(1)

    if not args.template:
        print(red("ERROR: --template is required. Use --list-templates to see options."))
        parser.print_help()
        sys.exit(1)

    if not validate_project_name(args.name):
        print(red(f"ERROR: Invalid project name '{args.name}'."))
        print(yellow("  Flutter project names must be lowercase with underscores."))
        print(yellow("  Examples: my_app, travel_ui, fintech_dashboard"))
        sys.exit(1)

    output = Path(args.output).expanduser().resolve()
    output.mkdir(parents=True, exist_ok=True)
    copy_template(args.template, args.name, output)


if __name__ == "__main__":
    main()

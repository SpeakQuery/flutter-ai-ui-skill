#!/usr/bin/env python3
"""
Flutter Project Analyser
Scans a Flutter project and reports UI/UX anti-patterns with improvement suggestions.

Usage:
    python analyse_flutter_project.py --path /path/to/flutter/project
    python analyse_flutter_project.py --path /path/to/flutter/project --fix-suggestions
    python analyse_flutter_project.py --path /path/to/flutter/project --json
"""

import os
import re
import sys
import json
import argparse
from pathlib import Path
from typing import List, Dict, Tuple, Optional


# ─── ANSI Colors ──────────────────────────────────────────────────────────────
RED    = "\033[91m"
YELLOW = "\033[93m"
GREEN  = "\033[92m"
CYAN   = "\033[96m"
BOLD   = "\033[1m"
RESET  = "\033[0m"


def bold(s: str) -> str: return f"{BOLD}{s}{RESET}"
def red(s: str) -> str:  return f"{RED}{s}{RESET}"
def yellow(s: str) -> str: return f"{YELLOW}{s}{RESET}"
def green(s: str) -> str: return f"{GREEN}{s}{RESET}"
def cyan(s: str) -> str:  return f"{CYAN}{s}{RESET}"


# ─── Issue Model ──────────────────────────────────────────────────────────────
class Issue:
    def __init__(self, severity: str, category: str, file: str,
                 line: Optional[int], message: str, suggestion: str):
        self.severity   = severity  # CRITICAL / HIGH / MEDIUM / LOW
        self.category   = category
        self.file       = file
        self.line       = line
        self.message    = message
        self.suggestion = suggestion

    def __repr__(self):
        loc = f":{self.line}" if self.line else ""
        sev_color = {"CRITICAL": RED, "HIGH": YELLOW, "MEDIUM": CYAN, "LOW": GREEN}
        color = sev_color.get(self.severity, RESET)
        return (
            f"{color}[{self.severity}]{RESET} {bold(self.category)} — "
            f"{self.message}\n"
            f"  📁 {self.file}{loc}\n"
            f"  💡 {self.suggestion}\n"
        )

    def to_dict(self) -> dict:
        return {
            "severity": self.severity,
            "category": self.category,
            "file": self.file,
            "line": self.line,
            "message": self.message,
            "suggestion": self.suggestion,
        }


# ─── File Scanner ─────────────────────────────────────────────────────────────
def find_dart_files(project_path: Path) -> List[Path]:
    """Find all .dart files under lib/."""
    lib_path = project_path / "lib"
    if not lib_path.exists():
        print(red(f"ERROR: No 'lib/' directory found at {project_path}"))
        sys.exit(1)
    return list(lib_path.rglob("*.dart"))


def read_file(path: Path) -> List[str]:
    try:
        return path.read_text(encoding="utf-8").splitlines()
    except Exception:
        return []


# ─── Checks ───────────────────────────────────────────────────────────────────
def check_hardcoded_colors(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    for i, line in enumerate(lines, 1):
        # Match Color(0xFF...) or Color(0xAA...)
        if re.search(r'Color\(0x[0-9A-Fa-f]{6,8}\)', line):
            issues.append(Issue(
                severity="CRITICAL", category="Theming",
                file=str(file), line=i,
                message="Hardcoded Color() value found",
                suggestion="Use Theme.of(context).colorScheme.* instead of hardcoded Color(0xFF...) values."
            ))
    return issues


def check_large_build_methods(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    in_build = False
    build_start = 0
    depth = 0

    for i, line in enumerate(lines, 1):
        stripped = line.strip()

        if re.match(r'Widget\s+build\(BuildContext\s+\w+\)', stripped):
            in_build = True
            build_start = i
            depth = 0

        if in_build:
            depth += stripped.count('{') - stripped.count('}')
            if depth <= 0 and i > build_start:
                build_len = i - build_start
                if build_len > 60:
                    issues.append(Issue(
                        severity="CRITICAL" if build_len > 100 else "HIGH",
                        category="Widgets",
                        file=str(file), line=build_start,
                        message=f"build() method is {build_len} lines long",
                        suggestion="Extract sub-widgets into separate Widget methods or classes. Keep build() < 50 lines."
                    ))
                in_build = False

    return issues


def check_missing_const(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    const_candidates = re.compile(
        r'(?<!\bconst\s)\b(Text|Icon|Padding|SizedBox|EdgeInsets|Column|Row|Container)\('
    )
    for i, line in enumerate(lines, 1):
        if const_candidates.search(line) and 'const ' not in line:
            if 'var ' not in line and '=' not in line.split('(')[0]:
                pass  # Too noisy to report every instance
    return issues  # Keep low noise — report in summary only


def check_stateful_ratio(file: Path, lines: List[str]) -> Tuple[int, int]:
    """Return (stateful_count, stateless_count)."""
    full = '\n'.join(lines)
    stateful  = len(re.findall(r'extends\s+StatefulWidget', full))
    stateless = len(re.findall(r'extends\s+StatelessWidget', full))
    return stateful, stateless


def check_dark_theme(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    full = '\n'.join(lines)
    if 'MaterialApp' in full and 'darkTheme' not in full and 'theme:' in full:
        issues.append(Issue(
            severity="HIGH", category="Theming",
            file=str(file), line=None,
            message="MaterialApp found without darkTheme",
            suggestion="Add darkTheme: ThemeData(brightness: Brightness.dark, colorScheme: ColorScheme.fromSeed(..., brightness: Brightness.dark)) to MaterialApp."
        ))
    return issues


def check_missing_semantics(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    full = '\n'.join(lines)
    image_count    = len(re.findall(r'Image\.(asset|network)\(', full))
    semantics_refs = len(re.findall(r'semanticsLabel|excludeFromSemantics', full))
    semantic_wrap  = len(re.findall(r'Semantics\(', full))

    if image_count > 0 and (semantics_refs + semantic_wrap) == 0:
        issues.append(Issue(
            severity="HIGH", category="Accessibility",
            file=str(file), line=None,
            message=f"{image_count} Image widget(s) found without any semanticsLabel or Semantics wrapper",
            suggestion="Add semanticsLabel: 'Description' to Image widgets, or wrap with Semantics(label: ...) or use excludeFromSemantics: true for purely decorative images."
        ))
    return issues


def check_listview_usage(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    for i, line in enumerate(lines, 1):
        # ListView with children: [...] directly
        if re.search(r'ListView\s*\(', line) and 'builder' not in line and 'separated' not in line:
            issues.append(Issue(
                severity="HIGH", category="Performance",
                file=str(file), line=i,
                message="ListView(...) used without .builder — may cause performance issues for large lists",
                suggestion="Use ListView.builder(itemCount: items.length, itemBuilder: ...) for lazy loading. Only use ListView(children: [...]) for very short, static lists."
            ))
    return issues


def check_setstate_in_build(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    in_build = False
    for i, line in enumerate(lines, 1):
        if re.match(r'\s*Widget\s+build\(', line):
            in_build = True
        if in_build and re.search(r'setState\s*\(', line):
            issues.append(Issue(
                severity="CRITICAL", category="State",
                file=str(file), line=i,
                message="setState() called inside or near build() method",
                suggestion="Only call setState() inside event handlers (onPressed, onChanged, etc.) not in build()."
            ))
        if in_build and line.strip().startswith('return '):
            in_build = False
    return issues


def check_context_after_async(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    for i, line in enumerate(lines, 1):
        # Naive check: context used after await without mounted check nearby
        if 'await ' in line and i < len(lines):
            nearby = '\n'.join(lines[i:min(i+5, len(lines))])
            if 'context' in nearby and 'mounted' not in nearby:
                issues.append(Issue(
                    severity="CRITICAL", category="State",
                    file=str(file), line=i+1,
                    message="BuildContext used after async gap without mounted check",
                    suggestion="Add 'if (!mounted) return;' or 'if (mounted) ...' before using BuildContext after any await."
                ))
    return issues


def check_cached_images(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    for i, line in enumerate(lines, 1):
        if re.search(r'Image\.network\(', line):
            issues.append(Issue(
                severity="HIGH", category="Performance",
                file=str(file), line=i,
                message="Image.network() used without caching",
                suggestion="Replace with CachedNetworkImage from 'cached_network_image' package for automatic caching and placeholder support."
            ))
    return issues


def check_material3(file: Path, lines: List[str]) -> List[Issue]:
    issues = []
    full = '\n'.join(lines)
    if 'ThemeData(' in full and 'useMaterial3' not in full:
        issues.append(Issue(
            severity="MEDIUM", category="Theming",
            file=str(file), line=None,
            message="ThemeData found without useMaterial3: true",
            suggestion="Add useMaterial3: true to ThemeData for the latest Material design system."
        ))
    return issues


def check_pubspec(project_path: Path) -> List[Issue]:
    issues = []
    pubspec = project_path / "pubspec.yaml"
    if not pubspec.exists():
        return issues
    content = pubspec.read_text()
    if 'cached_network_image' not in content:
        issues.append(Issue(
            severity="HIGH", category="Performance",
            file="pubspec.yaml", line=None,
            message="cached_network_image package not in dependencies",
            suggestion="Add cached_network_image: ^3.4.1 to pubspec.yaml for efficient image loading."
        ))
    if 'google_fonts' not in content:
        issues.append(Issue(
            severity="LOW", category="Theming",
            file="pubspec.yaml", line=None,
            message="google_fonts package not in dependencies",
            suggestion="Add google_fonts: ^6.2.1 to use 1000+ Google Fonts with zero configuration."
        ))
    if 'go_router' not in content:
        issues.append(Issue(
            severity="MEDIUM", category="Navigation",
            file="pubspec.yaml", line=None,
            message="go_router package not found",
            suggestion="Add go_router: ^14.0.0 for declarative, type-safe routing with deep link support."
        ))
    return issues


# ─── Main ─────────────────────────────────────────────────────────────────────
def analyse_project(project_path: str, fix_suggestions: bool = False, as_json: bool = False):
    path = Path(project_path)
    if not path.exists():
        print(red(f"ERROR: Path does not exist: {project_path}"))
        sys.exit(1)

    dart_files = find_dart_files(path)
    all_issues: List[Issue] = []
    total_stateful  = 0
    total_stateless = 0
    total_files     = len(dart_files)

    for file in dart_files:
        lines = read_file(file)
        rel = file.relative_to(path)

        all_issues.extend(check_hardcoded_colors(rel, lines))
        all_issues.extend(check_large_build_methods(rel, lines))
        all_issues.extend(check_dark_theme(rel, lines))
        all_issues.extend(check_missing_semantics(rel, lines))
        all_issues.extend(check_listview_usage(rel, lines))
        all_issues.extend(check_setstate_in_build(rel, lines))
        all_issues.extend(check_context_after_async(rel, lines))
        all_issues.extend(check_cached_images(rel, lines))
        all_issues.extend(check_material3(rel, lines))

        sf, sl = check_stateful_ratio(rel, lines)
        total_stateful  += sf
        total_stateless += sl

    all_issues.extend(check_pubspec(path))

    # Sort by severity
    sev_order = {"CRITICAL": 0, "HIGH": 1, "MEDIUM": 2, "LOW": 3}
    all_issues.sort(key=lambda i: sev_order.get(i.severity, 4))

    if as_json:
        print(json.dumps([i.to_dict() for i in all_issues], indent=2))
        return

    # ── Report ─────────────────────────────────────────────────────────────
    print(f"\n{bold('━' * 60)}")
    print(f"{bold('🎨 Flutter AI UI — Project Audit Report')}")
    print(f"{bold('━' * 60)}\n")
    print(f"  📁 Project : {project_path}")
    print(f"  🗂️  Files    : {total_files} Dart files analysed")
    print(f"  🧱 Widgets  : {total_stateful} StatefulWidget, {total_stateless} StatelessWidget")
    ratio = f"{total_stateful/(total_stateful+total_stateless)*100:.0f}%" if (total_stateful + total_stateless) > 0 else "–"
    print(f"  📊 Stateful ratio: {ratio} (target < 30%)")

    counts = {}
    for issue in all_issues:
        counts[issue.severity] = counts.get(issue.severity, 0) + 1

    print(f"\n  🔴 CRITICAL : {counts.get('CRITICAL', 0)}")
    print(f"  🟠 HIGH     : {counts.get('HIGH', 0)}")
    print(f"  🟡 MEDIUM   : {counts.get('MEDIUM', 0)}")
    print(f"  🟢 LOW      : {counts.get('LOW', 0)}")
    print(f"\n{bold('━' * 60)}\n")

    if not all_issues:
        print(green("✅ No major issues found! Great work."))
    else:
        for issue in all_issues:
            print(repr(issue))

    print(f"\n{bold('━' * 60)}")
    print(f"  Total issues: {len(all_issues)}")
    if all_issues:
        print(f"\n  Tip: Address CRITICAL issues first, then HIGH.")
        print(f"  Run with --json for machine-readable output.")
    print(f"{bold('━' * 60)}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Flutter AI UI — Project Audit Tool"
    )
    parser.add_argument("--path", required=True, help="Path to Flutter project root")
    parser.add_argument("--fix-suggestions", action="store_true", help="Show detailed fix suggestions")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    args = parser.parse_args()

    analyse_project(args.path, args.fix_suggestions, args.json)

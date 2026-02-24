<div align="center">

# 🎨 Flutter AI UI Skill

### Design intelligence for AI coding assistants — Flutter edition

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x%2B-02569B?logo=flutter)](https://flutter.dev)
[![Stars](https://img.shields.io/github/stars/eyupkutlu/flutter-ai-ui-skill?style=social)](https://github.com/eyupkutlu/flutter-ai-ui-skill)

**The most comprehensive Flutter UI/UX skill for AI coding assistants.**  
Instantly turns any AI into a Flutter design expert with curated palettes,
typography pairings, animation patterns, component blueprints and
production-grade checklists.

[Installation](#-installation) · [Features](#-features) · [Usage](#-usage) · [Documentation](#-documentation) · [Contributing](#-contributing)

</div>

---

## ✨ What is this?

**Flutter AI UI Skill** is a plug-in skill that supercharges AI coding
assistants (Antigravity, Claude Code, Cursor, Windsurf, Gemini CLI, and more)
with deep Flutter UI/UX knowledge.

Instead of getting generic code, you get:

- 🎨 **Curated palettes** matched to your app domain (healthcare, fintech, e-commerce…)
- 🔤 **Typography pairings** from Google Fonts, chosen for Flutter
- 📐 **Component blueprints** for common Flutter patterns
- ⚡ **Performance rules** built into every code suggestion
- ♿ **Accessibility built in** — WCAG AA from day one
- 🌗 **Dark mode by default** — always generates both themes
- 🧪 **Pre-delivery checklist** so nothing ships broken

---

## 🚀 Features

| Feature | Details |
|---------|---------|
| 🎨 **30+ Color Palettes** | Flutter app-type specific: healthcare, fintech, gaming, social, productivity… |
| 🔤 **15 Font Pairings** | Curated Google Fonts pairs with mood, use-case and Flutter import code |
| 📋 **120+ Guidelines** | Dos, don'ts and severity for widgets, state, layout, perf, a11y, nav, testing |
| 🖼️ **12 UI Styles** | Material 3, Glassmorphism, Neumorphism, Dark Neon, Claymorphism, Brutalist… |
| 🛠️ **3 Project Templates** | Material 3, Cupertino, and Adaptive multi-platform starters |
| 🔍 **Project Analyser** | Scans existing Flutter projects for anti-patterns and suggests fixes |
| 🔎 **Guideline Search** | Keyword/category/severity search across 120+ Flutter UI rules |
| 🤖 **13+ AI Platforms** | Works with all major AI coding assistants |

---

## 📦 Installation

Choose the method that matches your AI coding assistant:

### Method 1 — Antigravity (Recommended)

```bash
# Clone into your project's skills folder
git clone https://github.com/eyupkutlu/flutter-ai-ui-skill \
  .agents/skills/flutter-ai-ui-skill
```

The skill activates automatically when you ask for Flutter UI/UX work.

### Method 2 — Claude Code

```bash
git clone https://github.com/eyupkutlu/flutter-ai-ui-skill \
  .claude/skills/flutter-ai-ui-skill
```

Then add to your `CLAUDE.md`:
```markdown
## Skills
- skills/flutter-ai-ui-skill/SKILL.md
```

### Method 3 — Cursor

```bash
git clone https://github.com/eyupkutlu/flutter-ai-ui-skill \
  .cursor/skills/flutter-ai-ui-skill
```

Add to `.cursor/rules/flutter-ui.mdc`:
```
@flutter-ai-ui-skill/SKILL.md
```

### Method 4 — Windsurf

```bash
git clone https://github.com/eyupkutlu/flutter-ai-ui-skill \
  .windsurf/skills/flutter-ai-ui-skill
```

Add to `.windsurf/rules/flutter-ui.md`:
```
@flutter-ai-ui-skill/SKILL.md
```

### Method 5 — Gemini CLI

```bash
git clone https://github.com/eyupkutlu/flutter-ai-ui-skill \
  flutter-ai-ui-skill
```

Add to your `GEMINI.md`:
```markdown
## Active Skills
- flutter-ai-ui-skill/SKILL.md
```

### Method 6 — GitHub Copilot

```bash
git clone https://github.com/eyupkutlu/flutter-ai-ui-skill \
  .github/skills/flutter-ai-ui-skill
```

Add to `.github/copilot-instructions.md`:
```markdown
## Flutter UI/UX Skill
See: skills/flutter-ai-ui-skill/SKILL.md
```

### Method 7 — Continue

```bash
git clone https://github.com/eyupkutlu/flutter-ai-ui-skill \
  .continue/skills/flutter-ai-ui-skill
```

Add to `.continue/config.json`:
```json
{
  "rules": [".continue/skills/flutter-ai-ui-skill/SKILL.md"]
}
```

### Method 8 — Kiro

```bash
git clone https://github.com/eyupkutlu/flutter-ai-ui-skill \
  .kiro/skills/flutter-ai-ui-skill
```

### Method 9 — Roo Code / OpenCode / Zed

```bash
git clone https://github.com/eyupkutlu/flutter-ai-ui-skill \
  .roo/skills/flutter-ai-ui-skill
```

Reference `SKILL.md` in your rules file.

---

## 💡 Usage

### Skill Mode (Auto-activate)

Supported on: Antigravity, Claude Code, Cursor, Windsurf, Gemini CLI, Continue, OpenCode

Just ask naturally in your Flutter project:

```
Build a login screen with a glassmorphism card style
```

```
Design a dashboard for a healthcare app with dark mode
```

```
Create a product listing page for an e-commerce app, minimal style
```

```
Improve the UI of my home screen — it looks basic
```

### Slash Command Mode

Supported on: Kiro, GitHub Copilot, Roo Code

```
/flutter-ai-ui Build a settings screen for a fintech app
```

```
/flutter-ai-ui Analyse my existing project and suggest UI improvements
```

### Using the Scripts Directly

```bash
# Analyse an existing Flutter project
python scripts/analyse_flutter_project.py --path /path/to/your/flutter/project

# Search guidelines by keyword
python scripts/search_guidelines.py --keyword "animation"
python scripts/search_guidelines.py --category "accessibility"

# Scaffold a new project
python scripts/create_flutter_project.py --name my_app --template material3
python scripts/create_flutter_project.py --name my_app --template adaptive
```

---

## 📚 Documentation

### Data Files

| File | Contents |
|------|----------|
| `data/flutter_colors.csv` | 30+ app-type color palettes with hex codes |
| `data/flutter_typography.csv` | 15 Google Fonts pairings with Flutter import code |
| `data/stacks/flutter_guidelines.csv` | 120+ Flutter UI guidelines with severity levels |

### Templates

| Template | Description |
|----------|-------------|
| `templates/material3/` | Material 3 starter with light/dark theme, navigation |
| `templates/cupertino/` | iOS-native Cupertino starter |
| `templates/adaptive/` | Multi-platform adaptive starter (mobile + tablet + web) |

### Scripts

| Script | Description |
|--------|-------------|
| `scripts/analyse_flutter_project.py` | Scans Flutter codebase for UI anti-patterns |
| `scripts/search_guidelines.py` | Searches guideline CSV by keyword/category/severity |
| `scripts/create_flutter_project.py` | Scaffolds a new Flutter project from templates |

---

## 🎨 UI Styles Supported

| Style | Description |
|-------|-------------|
| Material 3 Clean | Google's latest design language |
| Cupertino Native | iOS-native aesthetics |
| Glassmorphism | Frosted glass, blur effects |
| Neumorphism | Soft embossed depth |
| Dark Neon | Glowing accents on dark backgrounds |
| Claymorphism | Soft, pillowy 3D components |
| Gradient Premium | Rich layered gradients |
| Minimal Flat | Clean, whitespace-focused |
| Brutalist | Bold, raw, high-contrast |
| Organic Biophilic | Natural forms and earth tones |
| Enterprise Dark | Professional dark dashboard |
| Retro/Y2K | Nostalgic, pixel-inspired |

---

## 🤖 Supported AI Platforms

| Platform | Method | Status |
|----------|--------|--------|
| **Antigravity** | Auto-activation | ✅ Full |
| **Claude Code** | CLAUDE.md skill | ✅ Full |
| **Cursor** | Rules file | ✅ Full |
| **Windsurf** | Rules file | ✅ Full |
| **GitHub Copilot** | Instructions file | ✅ Full |
| **Gemini CLI** | GEMINI.md | ✅ Full |
| **Kiro** | Spec/Hooks | ✅ Full |
| **Roo Code** | Rules | ✅ Full |
| **OpenCode** | Config | ✅ Full |
| **Continue** | Config rules | ✅ Full |
| **Zed** | Settings | ✅ Full |
| **Codex CLI** | System prompt | ✅ Full |
| **Codebuddy** | Rules | ✅ Full |

---

## 🏗️ Architecture

```
flutter-ai-ui-skill/
├── SKILL.md                          ← Core AI instruction file
├── README.md                         ← This file
├── LICENSE                           ← MIT License
├── data/
│   ├── flutter_colors.csv            ← Color palettes by app domain
│   ├── flutter_typography.csv        ← Google Fonts pairings for Flutter
│   └── stacks/
│       └── flutter_guidelines.csv    ← 120+ Flutter UI/UX guidelines
├── scripts/
│   ├── analyse_flutter_project.py    ← Project audit tool
│   ├── search_guidelines.py          ← Guideline search utility
│   └── create_flutter_project.py     ← Project scaffolder
└── templates/
    ├── material3/                    ← Material 3 starter project
    │   ├── lib/main.dart
    │   └── pubspec.yaml
    ├── cupertino/                    ← Cupertino starter
    │   ├── lib/main.dart
    │   └── pubspec.yaml
    └── adaptive/                     ← Adaptive multi-platform starter
        ├── lib/main.dart
        └── pubspec.yaml
```

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/new-color-palettes`
3. **Add** your improvements (new palettes, guidelines, templates, scripts)
4. **Test** that your additions work with at least one AI platform
5. **Submit** a pull request with a clear description

### Contribution Ideas
- 🎨 New color palettes for specific industries
- 🔤 New font pairings with Flutter code
- 📋 Additional Flutter UI guidelines
- 🖼️ New UI style descriptions
- 📝 Template improvements or new templates
- 🌐 Translations of the README
- 🐛 Bug fixes in scripts

---

## 📄 License

MIT License — free to use, modify, and distribute. See [LICENSE](LICENSE).

---

## ⭐ Support

If this skill helps you build better Flutter UIs, please:
- ⭐ **Star** this repository
- 🐛 **Report issues** if something doesn't work
- 💡 **Submit PRs** with improvements
- 📢 **Share** with the Flutter community

---

<div align="center">

**Built with ❤️ for the Flutter & AI developer community**

[GitHub](https://github.com/eyupkutlu/flutter-ai-ui-skill) · [Issues](https://github.com/eyupkutlu/flutter-ai-ui-skill/issues) · [Discussions](https://github.com/eyupkutlu/flutter-ai-ui-skill/discussions)

</div>

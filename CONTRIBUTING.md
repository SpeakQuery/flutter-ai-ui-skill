# Contributing to Flutter AI UI Skill

Thank you for considering contributing! This project exists because of community involvement. Every contribution — big or small — makes this skill better for every Flutter developer using AI.

---

## 🤝 Ways to Contribute

| Type | Examples |
|------|---------|
| 🎨 **New Color Palettes** | Add palettes for industries not yet covered |
| 🔤 **New Font Pairings** | Suggest Google Fonts pairs with Flutter usage code |
| 📋 **New Guidelines** | Add Flutter best practices not yet in the CSV |
| 🖼️ **New Templates** | Cupertino, adaptive, feature-specific starters |
| 🐛 **Bug Fixes** | Fix scripts, incorrect guidelines, broken templates |
| 📖 **Docs** | Improve README, translate to another language |
| 💡 **Examples** | Add a before/after example to `examples/` |

---

## 🚀 Getting Started

### 1. Fork & Clone

```bash
git clone https://github.com/YOUR_USERNAME/flutter-ai-ui-skill
cd flutter-ai-ui-skill
```

### 2. Make Your Changes

Follow the file structure:

```
flutter-ai-ui-skill/
├── data/
│   ├── flutter_colors.csv        ← Add palette rows here
│   ├── flutter_typography.csv    ← Add font pairing rows here
│   └── stacks/
│       └── flutter_guidelines.csv ← Add guideline rows here
├── scripts/                      ← Python utility scripts
├── templates/                    ← Flutter starter projects
└── examples/                     ← Showcase examples
```

### 3. Test Your Contribution

**For CSV data changes:**
```bash
# Verify the CSV is valid and has all required columns
python scripts/validate_csv.py
```

**For script changes:**
```bash
# Test the analyser on a sample project
python scripts/analyse_flutter_project.py --path templates/material3
```

**For template changes:**
```bash
cd templates/material3
flutter pub get
flutter analyze
flutter test
```

### 4. Submit a Pull Request

```bash
git checkout -b feature/add-fintech-palette
git add -A
git commit -m "feat: add more fintech color palettes"
git push origin feature/add-fintech-palette
```

Then open a PR on GitHub with:
- **What** you changed and **why**
- Screenshots if adding templates or examples
- The AI platform you tested with (if relevant)

---

## 📋 CSV Contribution Guidelines

### Color Palettes (`data/flutter_colors.csv`)

Required columns:
- `No` — Next sequential number
- `App Type` — Descriptive name
- `Primary`, `Secondary`, `CTA`, `Background`, `Surface`, `Text`, `Border` (Hex)
- `Dark Primary`, `Dark Background`, `Dark Surface` (Hex — for dark mode)
- `Notes` — Short rationale for color choices

**Rules:**
- Provide both light and dark mode colors
- Notes should explain the psychological/design reasoning
- Test contrast ratios before submitting (use [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/))

### Font Pairings (`data/flutter_typography.csv`)

Required columns:
- `Pairing Name`, `Category`, `Display Font`, `Body Font`
- `Mood Keywords`, `Best For`, `Flutter Package`, `Pub Dev URL`
- `pubspec Entry` — Exact YAML to add to pubspec.yaml
- `Flutter TextTheme Usage` — Exact Dart code snippet
- `Notes` — Why this pairing works

**Rules:**
- Must be available on Google Fonts (via `google_fonts` package)
- Include the complete Flutter code snippet
- Test in a real Flutter project before submitting

### Guidelines (`data/stacks/flutter_guidelines.csv`)

Required columns:
- `No`, `Category`, `Guideline`, `Do`, `Don't`, `Severity`, `Flutter Example`
- Severity: `Critical` / `High` / `Medium` / `Low`

**Rules:**
- Must be Flutter-specific (not generic programming advice)
- Include a brief Dart code snippet in `Flutter Example`
- Link to official Flutter docs if possible

---

## 🐛 Reporting Issues

Use GitHub Issues with one of these templates:
- **Bug Report** — Something is wrong or broken
- **Feature Request** — Suggest a new palette, guideline, or template
- **Question** — Ask about using the skill

Please search existing issues before creating a new one.

---

## 💬 Community

- **GitHub Discussions** — For questions and sharing screenshots of what you built
- **Issues** — For bugs and feature requests

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make Flutter development with AI better for everyone! 🙏

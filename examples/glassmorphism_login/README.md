# Glassmorphism Login

A beautiful frosted glass login screen for any app domain.

**AI Prompt used:**
> "Build a login screen with a glassmorphism card style, dark gradient background, email and password fields, and a Google sign-in option."

**Style:** Glassmorphism on a dark purple/indigo gradient background  
**Palette:** `Fintech Crypto` from `data/flutter_colors.csv`  
**Font:** Space Grotesk + DM Sans

## Preview

> Run `main.dart` in your Flutter project to see the result.

## Key Techniques

- `BackdropFilter` + `ImageFilter.blur` for frosted glass
- Gradient overlay using `LinearGradient`
- Translucent `Container` with `BoxDecoration`
- Stroke border via `Border.all(color: Colors.white24)`

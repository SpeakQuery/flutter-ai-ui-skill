import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

// ─── Breakpoints ─────────────────────────────────────────────────────────────
// Mobile  : < 600px  → Bottom NavigationBar
// Tablet  : 600-1200px → Side NavigationRail
// Desktop : > 1200px → Full NavigationDrawer
class Breakpoints {
  static const double tablet  = 600;
  static const double desktop = 1200;
}

// ─── Router ────────────────────────────────────────────────────────────────────
final _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/',        builder: (c, s) => const HomePage()),
        GoRoute(path: '/explore', builder: (c, s) => const ExplorePage()),
        GoRoute(path: '/profile', builder: (c, s) => const ProfilePage()),
      ],
    ),
  ],
);

// ─── App ─────────────────────────────────────────────────────────────────────
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Adaptive Starter',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}

// ─── Navigation Items ─────────────────────────────────────────────────────────
const _navItems = [
  (icon: Icons.home_outlined,   selected: Icons.home,          label: 'Home',    path: '/'),
  (icon: Icons.explore_outlined, selected: Icons.explore,      label: 'Explore', path: '/explore'),
  (icon: Icons.person_outline,  selected: Icons.person,        label: 'Profile', path: '/profile'),
];

// ─── App Shell (Adaptive Layout) ─────────────────────────────────────────────
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    return _navItems.indexWhere((n) => n.path == loc).clamp(0, _navItems.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width   = constraints.maxWidth;
      final isTablet  = width >= Breakpoints.tablet;
      final isDesktop = width >= Breakpoints.desktop;
      final idx = _currentIndex(context);

      if (isDesktop) {
        // ── Desktop: full drawer + body ──────────────────────────────────────
        return Scaffold(
          body: Row(children: [
            NavigationDrawer(
              selectedIndex: idx,
              onDestinationSelected: (i) => context.go(_navItems[i].path),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 24, 16, 10),
                  child: Text('Flutter Adaptive', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                ..._navItems.map((n) => NavigationDrawerDestination(
                  icon: Icon(n.icon), selectedIcon: Icon(n.selected), label: Text(n.label),
                )),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ]),
        );
      }

      if (isTablet) {
        // ── Tablet: rail ─────────────────────────────────────────────────────
        return Scaffold(
          body: Row(children: [
            NavigationRail(
              extended: false,
              selectedIndex: idx,
              onDestinationSelected: (i) => context.go(_navItems[i].path),
              destinations: _navItems.map((n) => NavigationRailDestination(
                icon: Icon(n.icon), selectedIcon: Icon(n.selected), label: Text(n.label),
              )).toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ]),
        );
      }

      // ── Mobile: bottom bar ──────────────────────────────────────────────────
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: idx,
          onDestinationSelected: (i) => context.go(_navItems[i].path),
          destinations: _navItems.map((n) => NavigationDestination(
            icon: Icon(n.icon), selectedIcon: Icon(n.selected), label: n.label,
          )).toList(),
        ),
      );
    });
  }
}

// ─── Pages ───────────────────────────────────────────────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Home', style: tt.titleLarge), backgroundColor: cs.surface),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.devices, size: 80, color: cs.primary),
            const SizedBox(height: 16),
            Text('Adaptive Layout', style: tt.headlineMedium),
            const SizedBox(height: 8),
            Text('Resize the window to see navigation adapt',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: const Center(child: Text('Explore Page')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Page')),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

// ─── App ─────────────────────────────────────────────────────────────────────
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Cupertino Starter',
      debugShowCheckedModeBanner: false,
      // Cupertino theme
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(
          primaryColor: CupertinoColors.systemBlue,
        ),
      ),
      home: const _MainTab(),
    );
  }
}

// ─── Main Tab Controller ──────────────────────────────────────────────────────
class _MainTab extends StatelessWidget {
  const _MainTab();

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return switch (index) {
              0 => const HomePage(),
              1 => const SearchPage(),
              _ => const ProfilePage(),
            };
          },
        );
      },
    );
  }
}

// ─── Home Page ────────────────────────────────────────────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home'),
        trailing: Icon(CupertinoIcons.bell),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Pull to refresh
            CupertinoSliverRefreshControl(onRefresh: () async {}),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.list(children: [
                // Hero card with iOS-style design
                _IosCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back 👋',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your beautiful iOS app starts here.',
                        style: TextStyle(
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        onPressed: () {},
                        child: const Text('Get Started'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // iOS-style list
                _IosListSection(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── iOS Card ─────────────────────────────────────────────────────────────────
class _IosCard extends StatelessWidget {
  const _IosCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

// ─── iOS List Section ─────────────────────────────────────────────────────────
class _IosListSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: const Text('Quick Actions'),
      children: [
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.star, color: CupertinoColors.systemYellow),
          title: const Text('Favorites'),
          trailing: const CupertinoListTileChevron(),
          onTap: () {},
        ),
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.settings, color: CupertinoColors.systemGray),
          title: const Text('Settings'),
          trailing: const CupertinoListTileChevron(),
          onTap: () {},
        ),
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.share, color: CupertinoColors.systemBlue),
          title: const Text('Share App'),
          trailing: const CupertinoListTileChevron(),
          onTap: () {},
        ),
      ],
    );
  }
}

// ─── Search Page ──────────────────────────────────────────────────────────────
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Search')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CupertinoSearchTextField(controller: _controller),
        ),
      ),
    );
  }
}

// ─── Profile Page ─────────────────────────────────────────────────────────────
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Profile')),
      child: Center(child: Text('Profile Page')),
    );
  }
}

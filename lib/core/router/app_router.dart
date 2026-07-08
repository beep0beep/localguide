import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/home_screen.dart';
import '../../screens/detail_screen.dart';
import '../../screens/map_screen.dart';
import '../../screens/favorites_screen.dart';
import '../../screens/settings_screen.dart';

class AppRouter {
  static const home = '/';
  static const detail = '/detail/:id';
  static const map = '/map';
  static const favorites = '/favorites';
  static const settings = '/settings';

  static final router = GoRouter(
    initialLocation: home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
            routes: [
              GoRoute(
                path: 'detail/:id',
                name: 'detail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return NoTransitionPage(child: DetailScreen(id: id));
                },
              ),
            ],
          ),
          GoRoute(
            path: map,
            name: 'map',
            pageBuilder: (context, state) => const NoTransitionPage(child: MapScreen()),
          ),
          GoRoute(
            path: favorites,
            name: 'favorites',
            pageBuilder: (context, state) => const NoTransitionPage(child: FavoritesScreen()),
          ),
          GoRoute(
            path: settings,
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(child: SettingsScreen()),
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  int _currentIndex(GoRouterState state) {
    final loc = state.matchedLocation;
    if (loc == AppRouter.home) return 0;
    if (loc == AppRouter.map) return 1;
    if (loc == AppRouter.favorites) return 2;
    if (loc == AppRouter.settings) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(GoRouterState.of(context)),
        onTap: (i) {
          switch (i) {
            case 0: context.go(AppRouter.home); break;
            case 1: context.go(AppRouter.map); break;
            case 2: context.go(AppRouter.favorites); break;
            case 3: context.go(AppRouter.settings); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Carte'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Réglages'),
        ],
      ),
    );
  }
}
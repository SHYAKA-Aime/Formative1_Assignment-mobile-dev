import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/explore/explore_screen.dart';
import 'screens/communities/communities_screen.dart';
import 'screens/chats/chats_screen.dart';
import 'screens/chats/chat_room_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/events/event_detail_screen.dart';
import 'screens/create/create_post_screen.dart';
import 'screens/faculty/faculty_screen.dart';
import 'screens/campus/campus_map_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const ALUConnectApp(),
    ),
  );
}

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),

    // Shell — bottom nav (Home, Explore, Communities)
    ShellRoute(
      builder: (context, state, child) => _Shell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/explore', builder: (_, __) => const ExploreScreen()),
        GoRoute(path: '/communities', builder: (_, __) => const CommunitiesScreen()),
      ],
    ),

    // Standalone screens with their own nav
    GoRoute(path: '/chats', builder: (_, __) => const ChatsScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),

    // Detail routes (no bottom nav)
    GoRoute(
      path: '/event/:id',
      builder: (_, state) => EventDetailScreen(eventId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/chat-room/:id',
      builder: (_, state) => ChatRoomScreen(chatId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/create-post', builder: (_, __) => const CreatePostScreen()),
    GoRoute(path: '/faculty', builder: (_, __) => const FacultyScreen()),
    GoRoute(path: '/campus-map', builder: (_, __) => const CampusMapScreen()),
  ],
);

// ── Bottom nav shell ─────────────────────────────────────────────────────────

class _Shell extends StatelessWidget {
  final Widget child;
  const _Shell({required this.child});

  static const _routes = ['/home', '/explore', '/communities', '/chats', '/profile'];

  int _index(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final i = _routes.indexWhere((r) => loc.startsWith(r));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final current = _index(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: _BottomNav(
        currentIndex: current,
        onTap: (i) => context.go(_routes[i]),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', active: currentIndex == 0, onTap: () => onTap(0)),
          _NavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Explore', active: currentIndex == 1, onTap: () => onTap(1)),
          // Communities — center position, styled as FAB
          GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people, color: Colors.white, size: 24),
            ),
          ),
          _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'Chat', active: currentIndex == 3, onTap: () => onTap(3)),
          _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', active: currentIndex == 4, onTap: () => onTap(4)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.navActive : AppColors.navInactive;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
            const SizedBox(height: 2),
            if (active) Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.navActive, shape: BoxShape.circle)),
          ],
        ),
      ),
    );
  }
}

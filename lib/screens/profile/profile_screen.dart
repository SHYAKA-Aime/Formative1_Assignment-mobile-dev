import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── Reuse the same constants from chats_screen.dart or your theme.dart ───────
const Color kBg = Color(0xFF0D1B2A);
const Color kCard = Color(0xFF152032);
const Color kAccentRed = Color(0xFFE63946);
const Color kAccentBlue = Color(0xFF1D6FA4);
const Color kTextPrimary = Color(0xFFEEF2FF);
const Color kTextSecondary = Color(0xFF8A9BB0);
const Color kBorder = Color(0xFF1E3148);

// ─── Mock profile data ────────────────────────────────────────────────────────
class UserProfile {
  final String name;
  final String campus;
  final String year;
  final String degree;
  final int events;
  final int communities;
  final int connections;

  const UserProfile({
    required this.name,
    required this.campus,
    required this.year,
    required this.degree,
    required this.events,
    required this.communities,
    required this.connections,
  });
}

const UserProfile mockProfile = UserProfile(
  name: 'Amara Diallo',
  campus: 'ALU Kigali',
  year: 'Year 2',
  degree: 'BSc Entrepreneurial Leadership',
  events: 12,
  communities: 4,
  connections: 87,
);

// ─── Profile menu items ───────────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});
}

const List<_MenuItem> menuItems = [
  _MenuItem(icon: Icons.article_outlined, label: 'My Posts'),
  _MenuItem(icon: Icons.bookmark_outline_rounded, label: 'Saved Opportunities'),
  _MenuItem(icon: Icons.event_available_outlined, label: 'My RSVPs'),
  _MenuItem(icon: Icons.notifications_none_rounded, label: 'Notifications'),
];

// ─── Profile Screen ───────────────────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _ProfileTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _AvatarSection(profile: mockProfile),
                    const SizedBox(height: 20),
                    _StatsRow(profile: mockProfile),
                    const SizedBox(height: 28),
                    _MenuSection(),
                    const SizedBox(height: 24),
                    _LogoutButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kAccentRed,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ─── Top bar ──────────────────────────────────────────────────────────────────
class _ProfileTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // TODO: open settings
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kCard,
                border: Border.all(color: kBorder),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: kTextSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Avatar + name + degree ───────────────────────────────────────────────────
class _AvatarSection extends StatelessWidget {
  final UserProfile profile;
  const _AvatarSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            // Avatar ring
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kAccentRed, width: 2.5),
              ),
              child: CircleAvatar(
                radius: 52,
                backgroundColor: kCard,
                child: Text(
                  profile.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: const TextStyle(
                    color: kTextPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Edit badge
            GestureDetector(
              onTap: () {
                // TODO: pick image
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kAccentRed,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          profile.name,
          style: const TextStyle(
            color: kTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${profile.campus} · ${profile.year}',
          style: const TextStyle(
            color: kTextSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.degree,
          style: const TextStyle(
            color: kTextSecondary,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final UserProfile profile;
  const _StatsRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(value: profile.events.toString(), label: 'Events'),
          _VerticalDivider(),
          _StatItem(
              value: profile.communities.toString(), label: 'Communities'),
          _VerticalDivider(),
          _StatItem(
              value: profile.connections.toString(), label: 'Connections'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: kTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: kTextSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: kBorder,
    );
  }
}

// ─── Menu section ─────────────────────────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          final isLast = index == menuItems.length - 1;
          return Column(
            children: [
              _MenuRow(item: item),
              if (!isLast)
                Divider(
                  color: kBorder,
                  height: 1,
                  thickness: 1,
                  indent: 54,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final _MenuItem item;
  const _MenuRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: navigate
      },
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: kAccentBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item.icon, color: kAccentBlue, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  color: kTextPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: kTextSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Logout button ────────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: handle logout
        },
        icon: const Icon(Icons.logout_rounded, size: 18, color: kAccentRed),
        label: const Text(
          'Log out',
          style: TextStyle(
            color: kAccentRed,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: kAccentRed, width: 1.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}


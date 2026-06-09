import 'package:flutter/material.dart';

// ─── Theme constants (match your team's theme.dart) ───────────────────────────
const Color kBg = Color(0xFF0D1B2A);
const Color kCard = Color(0xFF152032);
const Color kAccentRed = Color(0xFFE63946);
const Color kAccentBlue = Color(0xFF1D6FA4);
const Color kTextPrimary = Color(0xFFEEF2FF);
const Color kTextSecondary = Color(0xFF8A9BB0);
const Color kBorder = Color(0xFF1E3148);
const Color kFab = Color(0xFFE63946);

// ─── Mock data ─────────────────────────────────────────────────────────────────
class ChatPreview {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarInitials;
  final int unread;
  final Color avatarColor;

  const ChatPreview({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarInitials,
    this.unread = 0,
    required this.avatarColor,
  });
}

const List<ChatPreview> mockChats = [
  ChatPreview(
    name: 'Entrepreneurship Club',
    lastMessage: 'See you all tomorrow!',
    time: '12:46 PM',
    avatarInitials: 'EC',
    unread: 2,
    avatarColor: Color(0xFF6A3DE8),
  ),
  ChatPreview(
    name: 'AI Workshop',
    lastMessage: 'New resources shared...',
    time: '09:12 AM',
    avatarInitials: 'AI',
    unread: 1,
    avatarColor: Color(0xFF1D6FA4),
  ),
  ChatPreview(
    name: 'Campus Leaders',
    lastMessage: 'Meeting moved to Room 402',
    time: 'Yesterday',
    avatarInitials: 'CL',
    unread: 0,
    avatarColor: Color(0xFF2A9D8F),
  ),
  ChatPreview(
    name: 'LT3 Study Group',
    lastMessage: 'Who has the notes for session 3?',
    time: 'Tue',
    avatarInitials: 'LT',
    unread: 0,
    avatarColor: Color(0xFFE9C46A),
  ),
  ChatPreview(
    name: 'Sarah Mensah',
    lastMessage: 'Thanks for the help today!',
    time: 'Mon',
    avatarInitials: 'SM',
    unread: 0,
    avatarColor: Color(0xFFE76F51),
  ),
  ChatPreview(
    name: 'Kigali Innovation Hub',
    lastMessage: 'Don\'t forget the pitch deck!',
    time: 'Sun',
    avatarInitials: 'KI',
    unread: 0,
    avatarColor: Color(0xFF457B9D),
  ),
];

// ─── Chats Screen ──────────────────────────────────────────────────────────────
class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatPreview> _filtered = mockChats;

  void _onSearch(String query) {
    setState(() {
      _filtered = query.isEmpty
          ? mockChats
          : mockChats
              .where((c) =>
                  c.name.toLowerCase().contains(query.toLowerCase()) ||
                  c.lastMessage.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(),
            const SizedBox(height: 4),
            _SectionHeader(),
            const SizedBox(height: 12),
            _SearchBar(
              controller: _searchController,
              onChanged: _onSearch,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _filtered.isEmpty
                  ? _EmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        color: kBorder,
                        height: 1,
                        thickness: 1,
                      ),
                      itemBuilder: (context, index) =>
                          _ChatTile(chat: _filtered[index]),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _NewChatFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const _BottomNav(currentIndex: 2),
    );
  }
}

// ─── Top bar ──────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kAccentBlue,
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'ALU Connect',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.location_on_outlined,
                color: kTextSecondary, size: 22),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 14),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: kTextSecondary, size: 22),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ─── "Chats" heading + compose icon ──────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Chats',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // TODO: open new chat
            },
            child: const Icon(
              Icons.edit_square,
              color: kTextSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Search bar ───────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: kTextPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search chats...',
          hintStyle:
              const TextStyle(color: kTextSecondary, fontSize: 14),
          prefixIcon:
              const Icon(Icons.search, color: kTextSecondary, size: 20),
          filled: true,
          fillColor: kCard,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: kAccentBlue, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ─── Individual chat row ──────────────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  final ChatPreview chat;
  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: navigate to ChatDetailScreen
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: chat.avatarColor.withOpacity(0.85),
              ),
              child: Center(
                child: Text(
                  chat.avatarInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      color: chat.unread > 0
                          ? kTextPrimary
                          : kTextPrimary.withOpacity(0.85),
                      fontSize: 15,
                      fontWeight: chat.unread > 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    chat.lastMessage,
                    style: TextStyle(
                      color: chat.unread > 0
                          ? kTextSecondary.withOpacity(0.9)
                          : kTextSecondary,
                      fontSize: 13,
                      fontWeight: chat.unread > 0
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Time + unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: TextStyle(
                    color: chat.unread > 0 ? kAccentBlue : kTextSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                if (chat.unread > 0)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kAccentRed,
                    ),
                    child: Center(
                      child: Text(
                        chat.unread.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 52, color: kTextSecondary.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text(
            'No chats found',
            style: TextStyle(
              color: kTextSecondary.withOpacity(0.6),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FAB ──────────────────────────────────────────────────────────────────────
class _NewChatFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: new chat
      },
      backgroundColor: kFab,
      elevation: 4,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────
// Copy this widget once into a shared file (e.g. widgets/bottom_nav.dart)
// and reuse it across all screens.
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        border: Border(top: BorderSide(color: kBorder, width: 1)),
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  selected: currentIndex == 0),
              _NavItem(
                  icon: Icons.explore_outlined,
                  label: 'Explore',
                  selected: currentIndex == 1),
              const SizedBox(width: 48), // FAB gap
              _NavItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Chat',
                  selected: currentIndex == 2),
              _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  selected: currentIndex == 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem(
      {required this.icon, required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: wire up navigator
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selected ? kAccentBlue : kTextSecondary,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: selected ? kAccentBlue : kTextSecondary,
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _campus = 'Kigali';
  String _filter = 'All';
  final _searchController = TextEditingController();
  final _filters = ['All', 'Events', 'Internships', 'Hackathons', 'Workshops'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final events = provider.filterEvents(
      type: _filter,
      campus: _campus == 'All' ? null : _campus,
      query: _searchController.text,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildCampusToggle(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildFilterRow(),
            const SizedBox(height: 20),
            _buildSectionHeader(),
            const SizedBox(height: 12),
            Expanded(child: _buildList(events, provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Text(
            'Explore',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildCampusToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Kigali', 'Mauritius'].map((c) {
          final selected = _campus == c;
          return GestureDetector(
            onTap: () => setState(() => _campus = c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.accent : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                c,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search internships, events, etc...',
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.textHint, size: 20),
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final selected = _filter == f;
          return GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.accent : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recommended for You',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'See All',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Event> events, AppProvider provider) {
    if (events.isEmpty) {
      return const Center(
        child: Text('No results found', style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _EventCard(
        event: events[i],
        isSaved: provider.isSaved(events[i].id),
        onSave: () => provider.toggleSave(events[i].id),
        onTap: () => context.push('/event/${events[i].id}'),
      ),
    );
  }
}

// ── Event card ──────────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final Event event;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onTap;

  const _EventCard({
    required this.event,
    required this.isSaved,
    required this.onSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + bookmark
            Stack(
              children: [
                Image.network(
                  event.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_outlined, color: AppColors.textHint, size: 40),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onSave,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        size: 17,
                        color: isSaved ? AppColors.accent : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type + Campus badges
                  Row(
                    children: [
                      _TypeBadge(type: event.type),
                      const SizedBox(width: 6),
                      _CampusBadge(campus: event.campus),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Date/urgency row
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textHint),
                      const SizedBox(width: 5),
                      Text(
                        event.startsText ?? _formatDate(event),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  if (event.urgencyText != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 13, color: AppColors.urgent),
                        const SizedBox(width: 5),
                        Text(
                          event.urgencyText!,
                          style: const TextStyle(fontSize: 12, color: AppColors.urgent, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(Event e) {
    if (e.deadline != null) return 'Deadline: ${DateFormat('MMM d, y').format(e.deadline!)}';
    return 'Date: ${DateFormat('MMM d, y').format(e.date)}';
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: _bg(), borderRadius: BorderRadius.circular(6)),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _color()),
      ),
    );
  }

  Color _color() {
    switch (type) {
      case 'hackathon': return AppColors.hackathon;
      case 'internship': return AppColors.internship;
      case 'leadership': return AppColors.leadership;
      case 'program': return AppColors.program;
      case 'workshop': return AppColors.workshop;
      default: return AppColors.eventType;
    }
  }

  Color _bg() {
    switch (type) {
      case 'hackathon': return AppColors.hackathonLight;
      case 'internship': return AppColors.internshipLight;
      case 'leadership': return AppColors.leadershipLight;
      case 'program': return AppColors.programLight;
      case 'workshop': return AppColors.workshopLight;
      default: return AppColors.eventTypeLight;
    }
  }
}

class _CampusBadge extends StatelessWidget {
  final String campus;
  const _CampusBadge({required this.campus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: _bg(), borderRadius: BorderRadius.circular(6)),
      child: Text(
        campus.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _color()),
      ),
    );
  }

  Color _color() {
    switch (campus) {
      case 'Kigali': return AppColors.kigali;
      case 'Mauritius': return AppColors.mauritius;
      default: return AppColors.global;
    }
  }

  Color _bg() {
    switch (campus) {
      case 'Kigali': return AppColors.kigaliLight;
      case 'Mauritius': return AppColors.mauritiusLight;
      default: return AppColors.globalLight;
    }
  }
}

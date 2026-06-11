import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/event.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _activeFilter = 'All';
  final _filters = ['All', 'Events', 'Opportunities', 'Map'];

  @override
  Widget build(BuildContext context) {
    context.watch<AppProvider>();
    final featured = MockData.events.where((e) => e.isFeatured).toList();
    final opportunities = MockData.events
        .where((e) => e.type == 'internship' || e.type == 'program')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildSearchBar()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildFilterChips()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(child: _buildQuickActions()),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
            if (featured.isNotEmpty) ...[
              SliverToBoxAdapter(child: _buildSectionLabel('Featured Today')),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(child: _buildFeaturedCard(featured.first)),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
            if (opportunities.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _buildSectionLabel(
                  'Latest Opportunities',
                  trailing: 'See all',
                  onTrailingTap: () => context.go('/explore'),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(child: _buildOpportunitiesRow(opportunities)),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Amara \u{1F44B}',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "What's on today at ALU Kigali?",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          children: [
            SizedBox(width: 14),
            Icon(Icons.search, color: AppColors.textHint, size: 20),
            SizedBox(width: 8),
            Text(
              'Search events, people, rooms...',
              style: TextStyle(color: AppColors.textHint, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = _activeFilter == _filters[i];
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = _filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: active ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? AppColors.accent : AppColors.border,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _filters[i],
                style: TextStyle(
                  color: active ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        icon: Icons.grid_view_rounded,
        label: 'Find My Class',
        onTap: () {},
      ),
      _QuickAction(
        icon: Icons.person_search_outlined,
        label: 'Find Faculty',
        onTap: () => context.push('/faculty'),
      ),
      _QuickAction(
        icon: Icons.calendar_today_outlined,
        label: 'Events Today',
        onTap: () => context.go('/explore'),
      ),
      _QuickAction(
        icon: Icons.work_outline_rounded,
        label: 'Opportunities',
        onTap: () => context.go('/explore'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
        children: actions.map(_buildActionCard).toList(),
      ),
    );
  }

  Widget _buildActionCard(_QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(action.icon, color: AppColors.accent, size: 24),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title,
      {String? trailing, VoidCallback? onTrailingTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (trailing != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailing,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.push('/event/${event.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: AppColors.surfaceVariant,
                child: Image.network(
                  event.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Center(
                      child: Icon(Icons.image_outlined,
                          color: AppColors.textHint, size: 48),
                    ),
                  ),
                ),
              ),
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.campus != 'Global')
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.kigali,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.campus.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () => context.push('/event/${event.id}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunitiesRow(List<Event> opportunities) {
    return SizedBox(
      height: 148,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: opportunities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _buildOpportunityCard(opportunities[i]),
      ),
    );
  }

  Widget _buildOpportunityCard(Event event) {
    return GestureDetector(
      onTap: () => context.push('/event/${event.id}'),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.work_outline_rounded,
                  color: AppColors.textSecondary, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event.organizerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11),
            ),
            const SizedBox(height: 6),
            if ((event.urgencyText ?? event.startsText ?? '').isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 11, color: AppColors.urgent),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      event.urgencyText ?? event.startsText ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.urgent, fontSize: 10),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});
}



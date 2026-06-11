import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../models/faculty.dart';
import '../../theme/app_colors.dart';

class FacultyScreen extends StatefulWidget {
  const FacultyScreen({super.key});

  @override
  State<FacultyScreen> createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  String _activeCategory = 'All';
  String _activeDepartment = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final _categories = ['All', 'Academic', 'Admin', 'Support'];
  final _departments = ['All', 'Leadership', 'Tech', 'Entrepreneurship', 'Finance', 'Registry'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Faculty> get _filtered {
    return MockData.faculty.where((f) {
      final matchCategory =
          _activeCategory == 'All' || f.category == _activeCategory;
      final matchDept =
          _activeDepartment == 'All' || f.departmentTag == _activeDepartment;
      final matchSearch = _searchQuery.isEmpty ||
          f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          f.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          f.department.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchDept && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            const SizedBox(height: 6),
            _buildTitle(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 14),
            _buildCategoryChips(),
            const SizedBox(height: 20),
            _buildDepartmentSection(),
            const SizedBox(height: 16),
            Expanded(child: _buildFacultyList(results)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'ALU Connect',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          const Icon(Icons.location_on_outlined,
              color: AppColors.textSecondary, size: 22),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'People & Faculty',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
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
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, color: AppColors.textHint, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 14),
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: const InputDecoration(
                  hintText: 'Search by name, role, or department...',
                  hintStyle:
                      TextStyle(color: AppColors.textHint, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = _activeCategory == _categories[i];
          return GestureDetector(
            onTap: () => setState(() => _activeCategory = _categories[i]),
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
                _categories[i],
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

  Widget _buildDepartmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'BROWSE BY DEPARTMENT',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _departments.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              if (_departments[i] == 'All') return const SizedBox.shrink();
              final active = _activeDepartment == _departments[i];
              return GestureDetector(
                onTap: () => setState(() {
                  _activeDepartment =
                      active ? 'All' : _departments[i];
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: active
                          ? AppColors.accent
                          : AppColors.border,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _departments[i],
                    style: TextStyle(
                      color: active
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFacultyList(List<Faculty> items) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search_outlined,
                size: 56, color: AppColors.textHint),
            SizedBox(height: 12),
            Text('No results found',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _buildFacultyCard(items[i]),
    );
  }

  Widget _buildFacultyCard(Faculty faculty) {
    final isKigali = faculty.campus == 'Kigali';
    final campusColor = isKigali ? AppColors.kigali : AppColors.mauritius;
    final campusBg =
        isKigali ? AppColors.kigaliLight : AppColors.mauritiusLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.surfaceVariant,
                child: Text(
                  faculty.avatarInitials,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            faculty.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: campusBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            faculty.campus.toUpperCase(),
                            style: TextStyle(
                              color: campusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      faculty.title,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                    Text(
                      faculty.department,
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Message',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('View Profile',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

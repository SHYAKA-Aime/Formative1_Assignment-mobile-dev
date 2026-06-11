class Faculty {
  final String id;
  final String name;
  final String title;
  final String department;
  final String campus; // 'Kigali' | 'Mauritius'
  final String category; // 'Academic' | 'Admin' | 'Support'
  final String departmentTag; // 'Leadership' | 'Tech' | 'Entrepreneurship' | 'Finance' | 'Registry'
  final String avatarInitials;

  const Faculty({
    required this.id,
    required this.name,
    required this.title,
    required this.department,
    required this.campus,
    required this.category,
    required this.departmentTag,
    required this.avatarInitials,
  });
}

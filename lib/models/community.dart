class Community {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int memberCount;
  final bool isJoined;
  final bool isActiveThisWeek;

  const Community({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.memberCount,
    this.isJoined = false,
    this.isActiveThisWeek = false,
  });

  Community copyWith({bool? isJoined}) => Community(
        id: id,
        name: name,
        description: description,
        icon: icon,
        memberCount: memberCount,
        isJoined: isJoined ?? this.isJoined,
        isActiveThisWeek: isActiveThisWeek,
      );
}
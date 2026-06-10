class Event {
  final String id;
  final String title;
  final String description;
  final String type; // 'hackathon' | 'internship' | 'workshop' | 'event' | 'leadership' | 'program'
  final String imageUrl;
  final DateTime date;
  final String? timeRange; // e.g. "10:00 AM — 2:00 PM"
  final String location;
  final String campus; // 'Kigali' | 'Mauritius' | 'Both' | 'Global' | 'Online'
  final String organizerName;
  final String organizerAvatar;
  final List<String> attendeeIds;
  final int maxAttendees;
  final List<String> tags;
  final bool isUrgent;
  final DateTime? deadline;
  final String? urgencyText; // e.g. "Closes in 2 days"
  final String? startsText; // e.g. "Starts Jan 2026"
  final bool isFeatured;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.imageUrl,
    required this.date,
    this.timeRange,
    required this.location,
    required this.campus,
    required this.organizerName,
    required this.organizerAvatar,
    this.attendeeIds = const [],
    this.maxAttendees = 0,
    this.tags = const [],
    this.isUrgent = false,
    this.deadline,
    this.urgencyText,
    this.startsText,
    this.isFeatured = false,
  });

  int get attendeeCount => attendeeIds.length;

  Event copyWith({List<String>? attendeeIds}) => Event(
        id: id,
        title: title,
        description: description,
        type: type,
        imageUrl: imageUrl,
        date: date,
        timeRange: timeRange,
        location: location,
        campus: campus,
        organizerName: organizerName,
        organizerAvatar: organizerAvatar,
        attendeeIds: attendeeIds ?? this.attendeeIds,
        maxAttendees: maxAttendees,
        tags: tags,
        isUrgent: isUrgent,
        deadline: deadline,
        urgencyText: urgencyText,
        startsText: startsText,
        isFeatured: isFeatured,
      );
}

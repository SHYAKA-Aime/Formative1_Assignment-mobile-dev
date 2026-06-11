import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_colors.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isGoing = false;
  bool _isInterested = false;

  @override
  Widget build(BuildContext context) {
    final event = context.read<AppProvider>().getEvent(widget.eventId);

    if (event == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.textSecondary, size: 48),
              const SizedBox(height: 12),
              const Text('Event not found', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              TextButton(onPressed: () => context.pop(), child: const Text('Go back')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image
                Stack(
                  children: [
                    Image.network(
                      event.imageUrl,
                      width: double.infinity,
                      height: 240,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 240,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.image_outlined, color: AppColors.textHint, size: 48),
                      ),
                    ),
                    // Gradient overlay on image
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.background.withOpacity(0.7)],
                          ),
                        ),
                      ),
                    ),
                    // Back + share buttons
                    Positioned(
                      top: 44,
                      left: 16,
                      child: _iconBtn(Icons.arrow_back, () => context.pop()),
                    ),
                    Positioned(
                      top: 44,
                      right: 16,
                      child: _iconBtn(Icons.share_outlined, () {}),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: event.tags.map((tag) => _Tag(tag: tag)).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Info rows
                      _InfoRow(Icons.calendar_today_outlined, DateFormat('EEEE, MMMM d, y').format(event.date)),
                      if (event.timeRange != null) ...[
                        const SizedBox(height: 12),
                        _InfoRow(Icons.access_time_outlined, event.timeRange!),
                      ],
                      const SizedBox(height: 12),
                      _InfoRow(Icons.location_on_outlined, event.location),

                      const SizedBox(height: 24),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 20),

                      // About
                      const Text(
                        'About the Event',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Hosted by
                      const Text(
                        'HOSTED BY',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.surfaceVariant,
                            backgroundImage: NetworkImage(event.organizerAvatar),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            event.organizerName,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Fixed bottom buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // RSVP button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _isGoing = !_isGoing);
                        if (_isGoing) setState(() => _isInterested = false);
                        context.read<AppProvider>().toggleRsvp(widget.eventId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isGoing ? AppColors.success : AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _isGoing ? '✓ I\'m Going' : 'RSVP — I\'m Going',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Mark as Interested
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        _isInterested = !_isInterested;
                        if (_isInterested) _isGoing = false;
                      }),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _isInterested ? AppColors.accent : AppColors.textSecondary,
                        side: BorderSide(
                          color: _isInterested ? AppColors.accent : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _isInterested ? '✓ Interested' : 'Mark as Interested',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Add to Calendar + Invite Friends
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _BottomAction(Icons.calendar_month_outlined, 'Add to Calendar', () {}),
                      const SizedBox(width: 32),
                      _BottomAction(Icons.person_add_outlined, 'Invite Friends', () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String tag;
  const _Tag({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _BottomAction(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../data/mock_data.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // Events
  List<Event> _events = List.from(MockData.events);
  List<Event> get events => _events;

  final Set<String> _savedIds = {};
  final Set<String> _rsvpIds = {};

  bool isSaved(String id) => _savedIds.contains(id);
  bool isRsvped(String id) => _rsvpIds.contains(id);

  void toggleSave(String id) {
    _savedIds.contains(id) ? _savedIds.remove(id) : _savedIds.add(id);
    notifyListeners();
  }

  void toggleRsvp(String id) {
    _rsvpIds.contains(id) ? _rsvpIds.remove(id) : _rsvpIds.add(id);
    notifyListeners();
  }

  Event? getEvent(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Event> filterEvents({String? type, String? campus, String? query}) {
    return _events.where((e) {
      if (type != null && type != 'All' && e.type != type.toLowerCase()) return false;
      if (campus != null && campus != 'All') {
        if (e.campus != campus && e.campus != 'Both' && e.campus != 'Global') return false;
      }
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        return e.title.toLowerCase().contains(q) ||
            e.tags.any((t) => t.toLowerCase().contains(q));
      }
      return true;
    }).toList();
  }
}

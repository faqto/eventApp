import 'package:app/models/events_model.dart';
import 'package:flutter/material.dart';

class EventController extends ChangeNotifier {
  final List<Event> _events = [];

  // Read-only access
  List<Event> get events => List.unmodifiable(_events);

  // CREATE
  void addEvent(Event event) {
    if (!events.any((e) => e.id == event.id)) {
      _events.add(event);
      notifyListeners();
    }
  }

  // DELETE
  void removeEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // UPDATE
  void updateEvent(Event updated) {
    final index = _events.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _events[index] = updated;
      notifyListeners();
    }
  }

  // FILTERS
  List<Event> get upcoming =>
      events.where((e) => e.status == EventStatus.upcoming).toList();

  List<Event> get ongoing =>
      events.where((e) => e.status == EventStatus.ongoing).toList();

  List<Event> get ended =>
      events.where((e) => e.status == EventStatus.ended).toList();

  List<Event> get cancelled =>
      events.where((e) => e.status == EventStatus.cancelled).toList();

  void attendEvent(String eventId, String userId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final event = _events[index];
      _events[index] = event.copyWith(
        attendeeIds: {...event.attendeeIds, userId},
      );
      notifyListeners();
    }
  }

  void saveEvent(String eventId, String userId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final event = _events[index];
      _events[index] = event.copyWith(
        savedByIds: {...event.savedByIds, userId},
      );
      notifyListeners();
    }
  }

  void cancelAttendance(String eventId, String userId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final event = _events[index];
      _events[index] = event.copyWith(
        attendeeIds: {...event.attendeeIds}..remove(userId),
      );
      notifyListeners();
    }
  }

  void unsaveEvent(String eventId, String userId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final event = _events[index];
      _events[index] = event.copyWith(
        savedByIds: {...event.savedByIds}..remove(userId),
      );
      notifyListeners();
    }
  }

  Event? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

import 'package:app/models/events_model.dart';
import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  final List<Event> _events = [];

  // Read-only access
  List<Event> get events => List.unmodifiable(_events);

  // CREATE
  void addEvent(Event e) {
    _events.add(e);
    notifyListeners();
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
      _events.where((e) => e.status == EventStatus.upcoming).toList();

  List<Event> get ongoing =>
      _events.where((e) => e.status == EventStatus.ongoing).toList();

  List<Event> get ended =>
      _events.where((e) => e.status == EventStatus.ended).toList();

      
AppController() {
  _events.addAll([
    Event(
      "1",
      "Barangay Basketball",
      "Join us for an exciting barangay basketball tournament!",
      "Sports",
      DateTime(2026, 1, 5).toString(),
      "City Gym",
      EventStatus.upcoming,
    ),
    Event(
      "2",
      "Food Festival",
      "Hello and welcome to our annual food festival!",
      "Food",
      DateTime(2025, 12, 28).toString(),
      "Plaza",
      EventStatus.ended,
    ),
  ]);
}
}

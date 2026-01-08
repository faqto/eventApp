import 'dart:async';

import 'package:app/firestore_service.dart';
import 'package:app/models/events_model.dart';
import 'package:flutter/material.dart';

class EventController extends ChangeNotifier {
  final List<Event> _events = [];
  Timer? _statusTimer;
  final FirestoreService _firestoreService = FirestoreService(); // Add this

  EventController() {
    _statusTimer = Timer.periodic(Duration(seconds: 5), (_) {
      _autoUpdateStatuses();
    });
    _loadEventsFromFirestore(); // Load events from Firestore on initialization
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadEventsFromFirestore() async {
    try {
      _firestoreService.streamEvents().listen((firestoreEvents) {
        _events.clear();
        _events.addAll(firestoreEvents);
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  void _autoUpdateStatuses() {
    final now = DateTime.now();
    bool hasChanges = false;

    for (int i = 0; i < _events.length; i++) {
      final e = _events[i];
      if (e.status == EventStatus.cancelled || e.status == EventStatus.ended)continue;
      if (now.isAfter(e.endTime) && e.status != EventStatus.ended) {
        _events[i] = e.copyWith(status: EventStatus.ended);
        _firestoreService.addOrUpdateEvent(_events[i]); // Sync to Firestore
        hasChanges = true;
        continue;
      }
      if (now.isAfter(e.dateTime) &&
          now.isBefore(e.endTime) &&
          e.status != EventStatus.ongoing) {
        _events[i] = e.copyWith(status: EventStatus.ongoing);
        _firestoreService.addOrUpdateEvent(_events[i]); // Sync to Firestore
        hasChanges = true;
        continue;
      }
      if (now.isBefore(e.dateTime) && e.status != EventStatus.upcoming) {
        _events[i] = e.copyWith(status: EventStatus.upcoming);
        _firestoreService.addOrUpdateEvent(_events[i]); // Sync to Firestore
        hasChanges = true;
      }
    }

    if (hasChanges) {
      notifyListeners();
    }
  }

  bool cancelEvent(String eventId, String userId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index == -1) return false;

    final event = _events[index];

    if (event.hostId != userId) return false;
    if (event.status != EventStatus.upcoming) return false;

    _events[index] = event.copyWith(status: EventStatus.cancelled);
    _firestoreService.addOrUpdateEvent(_events[index]); // Sync to Firestore
    notifyListeners();
    return true;
  }

  List<Event> get events => List.unmodifiable(_events);

  void addEvent(Event event) {
    if (!events.any((e) => e.id == event.id)) {
      _events.add(event);
      _firestoreService.addOrUpdateEvent(event);
      notifyListeners();
    }
  }

  void removeEvent(String id) {
    final event = _events.firstWhere((e) => e.id == id, orElse: () => Event(
      id: '',
      title: '',
      description: '',
      category: '',
      dateTime: DateTime.now(),
      endTime: DateTime.now(),
      location: '',
      status: EventStatus.upcoming,
      hostId: '',
    ));
    
    if (event.id.isNotEmpty) {
      _events.removeWhere((e) => e.id == id);
      _firestoreService.deleteEvent(id);
      
      _firestoreService.deleteEventChatMessages(id);
      
      notifyListeners();
    }
  }

  void updateEvent(Event updated) {
    final index = _events.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _events[index] = updated;
      _firestoreService.addOrUpdateEvent(updated);
      notifyListeners();
    }
  }

  List<Event> get upcoming =>
      events.where((e) => e.status == EventStatus.upcoming).toList();

  List<Event> get ongoing =>
      events.where((e) => e.status == EventStatus.ongoing).toList();

  List<Event> get ended =>
      events.where((e) => e.status == EventStatus.ended).toList();

  List<Event> get cancelled =>
      events.where((e) => e.status == EventStatus.cancelled).toList();
  void attendEvent(String eventId, String userId) {
    _updateEventSet(
      eventId,
      (event) => event.copyWith(attendeeIds: {...event.attendeeIds, userId}),
    );
  }

  void saveEvent(String eventId, String userId) {
    _updateEventSet(
      eventId,
      (event) => event.copyWith(savedByIds: {...event.savedByIds, userId}),
    );
  }

  void cancelAttendance(String eventId, String userId) {
    _updateEventSet(
      eventId,
      (event) =>
          event.copyWith(attendeeIds: {...event.attendeeIds}..remove(userId)),
    );
  }

  void unsaveEvent(String eventId, String userId) {
    _updateEventSet(
      eventId,
      (event) =>
          event.copyWith(savedByIds: {...event.savedByIds}..remove(userId)),
    );
  }

  void _updateEventSet(String eventId, Event Function(Event) updateFn) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final event = _events[index];
      final updatedEvent = updateFn(event);
      _events[index] = updatedEvent;
      _firestoreService.addOrUpdateEvent(updatedEvent);
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

  List<Event> historyForUser(String userId) {
    return events
        .where(
          (e) =>
              (e.status == EventStatus.ended ||
                  e.status == EventStatus.cancelled) &&
              (e.hostId == userId ||
                  e.attendeeIds.contains(userId) ||
                  e.savedByIds.contains(userId)),
        )
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  List<Event> historyCreated(String userId) =>
      historyForUser(userId).where((e) => e.hostId == userId).toList();

  List<Event> historyJoined(String userId) => historyForUser(
    userId,
  ).where((e) => e.attendeeIds.contains(userId)).toList();

  List<Event> historySaved(String userId) => historyForUser(
    userId,
  ).where((e) => e.savedByIds.contains(userId)).toList();

  Event createEvent({
    required String title,
    required String description,
    required String category,
    required DateTime dateTime,
    required DateTime endTime,
    required String location,
    required String hostId,
  }) {
    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category.isEmpty ? "General" : category,
      dateTime: dateTime,
      endTime: endTime,
      location: location,
      status: EventStatus.upcoming,
      hostId: hostId,
      attendeeIds: {},
      savedByIds: {},
    );

    _events.add(event);
    _firestoreService.addOrUpdateEvent(event);
    notifyListeners();
    return event;
  }

  Future<void> syncAllEventsToFirestore() async {
    for (final event in _events) {
      await _firestoreService.addOrUpdateEvent(event);
    }
  }
}

import 'package:app/controllers/event_controller.dart';
import 'package:app/controllers/user_controller.dart';
import 'package:app/models/events_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/pages/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  final UserController userController;
  final EventController eventController;

  AppController(this.userController, this.eventController) {
    _seedEvents();
  }

  User get currentUser => userController.currentUser;

  //sample events
  void _seedEvents() {
    final sampleEvents = [
      Event(
        id: "1",
        title: "Gooning Tournament",
        description: "Join us for an exciting Worldcup gooning tournament!",
        category: "Sports",
        dateTime: DateTime(2026, 1, 5),
        location: "City Gym",
        status: EventStatus.upcoming,
        hostId: 'u1',
        attendeeIds: {},
        savedByIds: {},
      ),
      Event(
        id: "2",
        title: "Food Festival",
        description: "Hello and welcome to our annual food festival!",
        category: "Food",
        dateTime: DateTime(2025, 12, 28),
        location: "Plaza",
        status: EventStatus.upcoming,
        hostId: "u2",
        attendeeIds: {},
        savedByIds: {},
      ),
      Event(
        id: "2",
        title: "Food Festival",
        description: "Hello and welcome to our annual food festival!",
        category: "Food",
        dateTime: DateTime(2025, 12, 28),
        location: "Plaza",
        status: EventStatus.ongoing,
        hostId: "u2",
        attendeeIds: {},
        savedByIds: {},
      ),
    ];

    for (var e in sampleEvents) {
      eventController.addEvent(e);
    }
  }

  //app getters
  List<Event> get hostedEvents =>
      eventController.events.where((e) => e.hostId == currentUser.id).toList();

  int get hostedCount => hostedEvents.length;

  int get attendedCount => eventController.events
      .where((e) => e.attendeeIds.contains(currentUser.id))
      .length;

  int get savedCount => eventController.events
      .where((e) => e.savedByIds.contains(currentUser.id))
      .length;
  
  //check for joined and hosted
  List<Event> get myActiveEvents {
    return eventController.events.where((e) {
      final isHost = e.hostId == currentUser.id;
      final isJoined = e.attendeeIds.contains(currentUser.id);

      final isActive =
          e.status != EventStatus.ended &&
          e.status != EventStatus.cancelled;

      return (isHost || isJoined) && isActive;
    }).toList();
  }

  //event helpers
  User? getEventHost(Event e) => userController.getUserById(e.hostId);
  String getEventHostName(Event e) => getEventHost(e)?.name ?? "Unknown";

  //event actions
  void saveEvent(String eventId) =>
      eventController.saveEvent(eventId, currentUser.id);

  void unsaveEvent(String eventId) =>
      eventController.unsaveEvent(eventId, currentUser.id);

  void joinEvent(String eventId) {
    final event = eventController.getEventById(eventId);
    if (event == null) return;

    final ids = Set<String>.from(event.attendeeIds);
    ids.contains(currentUser.id) ? ids.remove(currentUser.id) : ids.add(currentUser.id);

    eventController.updateEvent(event.copyWith(attendeeIds: ids));
    notifyListeners();
  }

  bool hasJoined(String eventId) =>
      eventController.getEventById(eventId)?.attendeeIds.contains(currentUser.id) ?? false;

  Future<void> confirmAndLogout(BuildContext context) async {
    if (await LogoutDialog.show(context) == true) {
      await userController.logout();
    }
  }

  


}

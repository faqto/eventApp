import 'package:app/auth.dart';
import 'package:app/controllers/event_controller.dart';
import 'package:app/controllers/user_controller.dart';
import 'package:app/models/events_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/pages/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  final UserController userController;
  final EventController eventController;
  
  AppController(this.userController, this.eventController);
  
  // Change to nullable
  User? get currentUser => userController.currentUser;

  // Update all methods to handle nullable user
  List<Event> get hostedEvents {
    final user = currentUser;
    if (user == null || user.id.isEmpty) return [];
    return eventController.events.where((e) => e.hostId == user.id).toList();
  }

  int get hostedCount => hostedEvents.length;

  int get attendedCount {
    final user = currentUser;
    if (user == null || user.id.isEmpty) return 0;
    return eventController.events
        .where((e) => e.attendeeIds.contains(user.id))
        .length;
  }

  int get savedCount {
    final user = currentUser;
    if (user == null || user.id.isEmpty) return 0;
    return eventController.events
        .where((e) => e.savedByIds.contains(user.id))
        .length;
  }

  List<Event> get myActiveEvents {
    final user = currentUser;
    if (user == null || user.id.isEmpty) return [];
    return eventController.events.where((e) {
      final isHost = e.hostId == user.id;
      final isJoined = e.attendeeIds.contains(user.id);
      final isActive =
          e.status != EventStatus.ended && e.status != EventStatus.cancelled;
      return (isHost || isJoined) && isActive;
    }).toList();
  }

  User? getEventHost(Event e) => userController.getUserById(e.hostId);
  String getEventHostName(Event e) => getEventHost(e)?.name ?? "Unknown";

  void saveEvent(String eventId) {
    final user = currentUser;
    if (user == null || user.id.isEmpty) return;
    eventController.saveEvent(eventId, user.id);
    notifyListeners();
  }

  void unsaveEvent(String eventId) {
    final user = currentUser;
    if (user == null || user.id.isEmpty) return;
    eventController.unsaveEvent(eventId, user.id);
    notifyListeners();
  }

  void joinEvent(String eventId) {
    final user = currentUser;
    if (user == null || user.id.isEmpty) return;
    
    final event = eventController.getEventById(eventId);
    if (event == null) return;

    final ids = Set<String>.from(event.attendeeIds);
    ids.contains(user.id)
        ? ids.remove(user.id)
        : ids.add(user.id);

    eventController.updateEvent(event.copyWith(attendeeIds: ids));
    notifyListeners();
  }

  bool hasJoined(String eventId) {
    final user = currentUser;
    if (user == null || user.id.isEmpty) return false;
    return eventController
        .getEventById(eventId)
        ?.attendeeIds
        .contains(user.id) ??
        false;
  }

  Future<void> confirmAndLogout(BuildContext context) async {
    if (await LogoutDialog.show(context) == true) {
      await Auth().signOut();
      userController.clearUser();
      notifyListeners();
    }
  }
}
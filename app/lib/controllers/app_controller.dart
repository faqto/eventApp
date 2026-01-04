import 'package:app/controllers/event_controller.dart';
import 'package:app/controllers/user_controller.dart';
import 'package:app/models/events_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/pages/items/logout_dialog.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  late User currentUser;
  final UserController userController;
  final EventController eventController;

   final sampleusers = [
    User(id: "u2", name: "Jane", email: "jane@example.com",passwordHash: _hashPassword("1234")),
    User(id: "u1", name: "BadGumball", email: "bad@ahh.com",passwordHash: _hashPassword("admin")),
  ];

  
  AppController(this.userController, this.eventController) {
    currentUser = sampleusers[1]; 
    final sampleEvents = [
      Event(
        "1",
        "Gooning Tournament",
        "Join us for an exciting Worldcup gooning tournament!",
        "Sports",
        DateTime(2026, 1, 5),
        "City Gym",
        EventStatus.upcoming,
        'u1',
        <String>{},
        <String>{},
      ),
      Event(
        "2",
        "Food Festival",
        "Hello and welcome to our annual food festival!",
        "Food",
        DateTime(2025, 12, 28),
        "Plaza",
        EventStatus.ended,
        "u2",
        <String>{},
        <String>{},
      ),
      Event(
        "420",
        "Gooning for a Cause",
        "help the others goon better",
        "Community",
        DateTime(2026, 1, 5),
        "Gay bar",
        EventStatus.cancelled,
        "u1",
        <String>{},
        <String>{},
      ),
    ];

    //sameple hosted events
    for (var e in sampleEvents) {
      eventController.addEvent(e);
    }
  }
  List<Event> get hostedEvents =>
      eventController.events.where((e) => e.hostId == currentUser.id).toList();

  //user stats
  int get hostedCount =>
      eventController.events.where((e) => e.hostId == currentUser.id).length;

  int get attendedCount => eventController.events
      .where((e) => e.attendeeIds.contains(currentUser.id))
      .length;

  int get savedCount => eventController.events
      .where((e) => e.savedByIds.contains(currentUser.id))
      .length;

  //USER EVENT CONTROLS
  void attendEvent(String eventId) {
    eventController.attendEvent(eventId, currentUser.id);
  }

  void saveEvent(String eventId) {
    eventController.saveEvent(eventId, currentUser.id);
  }

  void cancelAttendance(String eventId) {
    eventController.cancelAttendance(eventId, currentUser.id);
  }

  void unsaveEvent(String eventId) {
    eventController.unsaveEvent(eventId, currentUser.id);
  }

  void logout(BuildContext context) {
    currentUser = User.empty();
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
  }

  bool get isLoggedIn => currentUser.id.isNotEmpty;

  // LOGIN
  bool login(String name, String password) {
    final user = sampleusers.firstWhere(
      (u) => u.name.toLowerCase() == name.toLowerCase(),
      orElse: () => User.empty(),
    );

    if (user.id.isEmpty) return false;

    if (user.passwordHash == _hashPassword(password)) {
      currentUser = user;
      notifyListeners();
      return true;
    }

    return false; // wrong password
  }

  //hash password
  static String _hashPassword(String password) {
    return password.codeUnits.fold(0, (a, b) => a + b).toString();
  }

  //check password
  bool verifyPassword(String password) {
    final hashedInput = _hashPassword(password);
    return hashedInput == currentUser.passwordHash;
  }

  // REGISTER account
    String? register(String name, String password) {
    if (name.trim().isEmpty || password.length < 4) {
      return "Username or password is invalid";
    }

    final exists = sampleusers.any(
      (u) => u.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return "Username already exists";
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: '$name@example.com',
      passwordHash: _hashPassword(password),
      isLoggedIn: true,
    );

    sampleusers.add(newUser);
    currentUser = newUser;
    notifyListeners();

    return null; // success
  }


  Future<void> confirmAndLogout(BuildContext context) async {
  final confirm = await LogoutDialog.show(context);

  if (confirm == true) {
    logout(context);
  }
}

}

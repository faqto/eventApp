import 'package:app/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/create_event_page.dart';
import 'package:app/pages/event_history_page.dart';
import 'package:app/pages/chat_event_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/pages/modify_event_page.dart';
import 'package:app/pages/register_page.dart';
import 'package:app/pages/event_details_page.dart';
import 'package:app/models/events_model.dart';
import 'package:app/routes/routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.eventDetails:
        return _eventRoute(settings, (event) => EventDetailsPage(event: event));
      case Routes.modifyEvent:
        return _eventRoute(settings, (event) => ModifyEventPage(event: event));
      case Routes.eventChat:
        return _eventRoute(settings, (event) => EventChatPage(event: event));

      case Routes.createEvent:
        return MaterialPageRoute(builder: (_) => const CreateEventPage());

      case Routes.eventHistory:
        return MaterialPageRoute(builder: (_) => const EventHistoryPage());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
        
      case Routes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
   

      case Routes.main:
      default:
        return _errorRoute("Route not found");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text(message)),
      ),
    );
  }

  static Route<dynamic> _eventRoute(
    RouteSettings settings,
    Widget Function(Event event) builder,
  ) {
    final args = settings.arguments;
    if (args is Event) {
      return MaterialPageRoute(builder: (_) => builder(args));
    }
    return _errorRoute("Event data is missing or invalid");
  }
}

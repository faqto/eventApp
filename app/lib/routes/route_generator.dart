import 'package:app/pages/about_page.dart';
import 'package:app/pages/create_event_page.dart';
import 'package:app/pages/event_history_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/pages/modify_event_page.dart';
import 'package:app/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/main_page.dart';
import 'package:app/pages/event_details_page.dart';
import 'package:app/models/events_model.dart';
import 'package:app/routes/routes.dart';
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    
    switch (settings.name) {

      case Routes.eventDetails:
        final event = settings.arguments as Event;
        return MaterialPageRoute(
          builder: (_) => EventDetailsPage(event: event),
        );

      case Routes.modifyEvent:
        final event = settings.arguments as Event;
        return MaterialPageRoute(
          builder: (_) => ModifyEventPage(event: event),
        );
      case Routes.createEvent:
        return MaterialPageRoute(
          builder: (_) => const CreateEventPage(),
        );
      case Routes.eventHistory:
        return MaterialPageRoute(
          builder: (_) => const EventHistoryPage(),
        );
      case Routes.about:
        return MaterialPageRoute(
          builder: (_) => const AboutPage(),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
        );
      

      case Routes.main:
      default:
        return MaterialPageRoute(builder: (_) => const MainPage());
    }
  }
}

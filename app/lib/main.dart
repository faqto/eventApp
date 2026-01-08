import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:app/controllers/user_controller.dart';
import 'package:app/controllers/event_controller.dart';
import 'package:app/controllers/chat_controller.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/routes/route_generator.dart';
import 'package:app/firebase_options.dart';
import 'package:app/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final userController = UserController();
  final eventController = EventController();
  final chatController = ChatController();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserController>.value(value: userController),
        ChangeNotifierProvider<EventController>.value(value: eventController),
        ChangeNotifierProvider<ChatController>.value(value: chatController),
        ChangeNotifierProvider<AppController>(
          create: (_) => AppController(userController, eventController),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const AuthWrapper(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/chat_controller.dart';
import 'package:app/controllers/event_controller.dart';
import 'package:app/controllers/user_controller.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/pages/main_page.dart';
import 'package:app/routes/route_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userController = UserController();
  final eventController = EventController();
  final chatController = ChatController();
  userController.addSampleUsers();

  await userController.restoreCurrentUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userController),
        ChangeNotifierProvider.value(value: eventController),
        ChangeNotifierProvider.value(value: chatController),

       
        ChangeNotifierProvider(
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
    final user = context.watch<UserController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: user.isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}

import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/event_controller.dart';
import 'package:app/controllers/user_controller.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/pages/main_page.dart';
import 'package:app/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => EventController()),
        ChangeNotifierProxyProvider2<UserController, EventController, AppController>(
          create: (_) => AppController(UserController(), EventController()),
          update: (_, userCtrl, eventCtrl, __) => AppController(userCtrl, eventCtrl),
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
     final app = context.watch<AppController>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: app.isLoggedIn? const MainPage() : const LoginPage(),
    );
  }
}

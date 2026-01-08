import 'package:app/controllers/app_controller.dart';
import 'package:app/pages/main_page.dart';
import 'package:app/pages/widgets/button_action_tile.dart';
import 'package:flutter/material.dart';
import 'package:app/models/buttons_model.dart';
import 'package:app/routes/routes.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});
  @override
  Widget build(BuildContext context) {
    final List<ButtonAction> menuActions = [

      ButtonAction(
        title: "Create Event",
        icon: Icons.add_circle_outline,
        color: Colors.grey.shade300,
        onTap: () => Navigator.pushNamed(context, Routes.createEvent),
      ),
      ButtonAction(
        title: "Browse Events",
        icon: Icons.search_rounded,
        color: Colors.grey.shade300,
        onTap: () => MainPage.jumpTo(context, 2),
      ),
      ButtonAction(
        title: "My Profile",
        icon: Icons.person_outline,
        color: Colors.grey.shade300,
        onTap: () => MainPage.jumpTo(context, 0),
      ),
      ButtonAction(
        title: "Event History",
        icon: Icons.history_rounded,
        color: Colors.grey.shade300,
        onTap: () => Navigator.pushNamed(context, Routes.eventHistory),
      ),
      ButtonAction(
        title: "Logout",
        icon: Icons.logout_rounded,
        color: Colors.red.shade300,
        onTap: () {
          context.read<AppController>().confirmAndLogout(context);
        },
      ),
    ];

      return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: menuActions
              .map((action) => ButtonActionTile(action: action))
              .toList(),
        ),
      ),
    );

  }
}

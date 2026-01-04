import 'package:app/controllers/app_controller.dart';
import 'package:app/pages/items/button_action_list.dart';
import 'package:app/pages/main_page.dart';
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
        color: Colors.grey.shade300,
        onTap: () => Navigator.pushNamed(context, Routes.createEvent),
      ),
      ButtonAction(
        title: "Browse Events",
        color: Colors.grey.shade300,
        onTap: () => MainPage.jumpTo(context, 2),
      ),
      ButtonAction(
        title: "My Profile",
        color: Colors.grey.shade300,
        onTap: () => MainPage.jumpTo(context, 0),
      ),
     
      ButtonAction(
        title: "Event History",
        color: Colors.grey.shade300,
        onTap: () => Navigator.pushNamed(context, Routes.eventHistory),
      ),
      ButtonAction(
        title: "About Us",
        color: Colors.grey.shade300,
        onTap: () => Navigator.pushNamed(context, Routes.about),
      ),
      ButtonAction(
        title: "Logout",
        color: Colors.red.shade300,
        onTap: (){
            context.read<AppController>().confirmAndLogout(context);
        },
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ButtonActionList(actions: menuActions),
      ),
    );
  }
}

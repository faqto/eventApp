import 'package:app/pages/chat_page.dart';
import 'package:app/pages/events_page.dart';
import 'package:app/pages/menu_page.dart';
import 'package:app/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> pages = [
    ProfilePage(),
    ChatPage(),
    EventsPage(),
    MenuPage(),
  ];

   final List<String> title = [
    "Profile",
    "Messages",
   'Events',
    "Menu",
  ];

  int currentpage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title[currentpage]),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: pages[currentpage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,

        currentIndex: currentpage,
        onTap: (value) {
          setState(() {
            currentpage = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'events',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'menu'),
        ],
      ),
    );
  }
}

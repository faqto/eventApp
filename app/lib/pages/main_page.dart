import 'package:app/pages/chat_lists_page.dart';
import 'package:app/pages/events_page.dart';
import 'package:app/pages/menu_page.dart';
import 'package:app/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});


  static void jumpTo(BuildContext context, int pageIndex) {
    final state = context.findAncestorStateOfType<_MainPageState>();
    state?._setPage(pageIndex);
  }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<String> title = ["Profile", "Messages", 'Events', "Menu"];
  final List<Widget> pages = [
    ProfilePage(),
    ChatListsPage(),
    EventsPage(),
    MenuPage(),
  ];

  int _currentpage = 0;

  void _setPage(int i) {
    setState(() => _currentpage = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title[_currentpage]),
        centerTitle: true,
        backgroundColor: Color(0xFFB39DFF),
      ),

      body: pages[_currentpage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,

        currentIndex: _currentpage,
        onTap: (i) => setState(() => _currentpage = i),

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

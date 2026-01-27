import 'package:flutter/material.dart';
import 'package:todo_app/settingpage.dart';

import 'calender .dart';
import 'homescreen.dart';
import 'menuepage.dart';

class Bottomnavigationbarscreen extends StatefulWidget {
  final int initialindex;
  const Bottomnavigationbarscreen({super.key,this.initialindex=0});

  @override
  State<Bottomnavigationbarscreen> createState() => _BottomnavigationbarscreenState();
}

class _BottomnavigationbarscreenState extends State<Bottomnavigationbarscreen> {
  late int myIndex;
  @override
  void initState() {
    super.initState();
    myIndex=widget.initialindex;
  }
  final List<Widget> screens = [
    HomePage(),
    MenuPage(),
    CalenderPage(),
    LogoutScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myIndex,
        children: screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.white,
          currentIndex: myIndex,
          onTap: (value) {
            setState(() {
              myIndex = value;
            });
          },
          iconSize: 35,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF05243E),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.menu_open_sharp), label: ""),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: "",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
          ],
        ),
      ),
    );
  }
}

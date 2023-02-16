import 'package:birthday/theme.dart';
import 'package:birthday/widget/today_widget.dart';
import 'package:birthday/widget/tomorrow_widget.dart';
import 'package:birthday/widget/yesterday_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';


class PersonilPage extends StatefulWidget {
  const PersonilPage({super.key});

  @override
  State<PersonilPage> createState() => _PersonilPageState();
}

class _PersonilPageState extends State<PersonilPage> {
 

  final minWidth = 500.0;
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    YesterdayWidget(),
    TodayWidget(),
    TomorrowWidget(),
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: mainColor,
              hoverColor: mainColor,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: secondColor,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: LineIcons.calendarMinus,
                  text: 'Kemarin',
                ),
                GButton(
                  icon: LineIcons.calendarCheck,
                  text: 'Hari Ini',
                ),
                GButton(
                  icon: LineIcons.calendarPlus,
                  text: 'Besok',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

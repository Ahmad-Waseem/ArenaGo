import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/TriggerMenu_Profilebutton';

// homepage.dart

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: friends',
      style: optionStyle,
    ),
    Text(
      'Index 2: Search',
      style: optionStyle,
    ),
    Text(
      'Index 3: history',
      style: optionStyle,
    ),
    Text(
      'Index 4: profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
    });
    if (index == 4) {
    //Navigate to ProfilePage when "ProfileButton" is selected
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TriggerMenu_ProfileButton(),
    ));
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArenaGo'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(

          backgroundColor: dBackgroundColor, 
          
          unselectedItemColor: loginOutlinecolor,
          
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt),
              label: 'Play Buddies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search), // Replace with your desired icon
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_toggle_off), // Replace with your desired icon
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), // Replace with your desired icon
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

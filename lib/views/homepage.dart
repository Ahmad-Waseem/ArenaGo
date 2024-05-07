import 'package:arenago/views/ProfileScreen.dart';
<<<<<<< Updated upstream

=======
import 'package:arenago/views/friends.dart';
import 'package:arenago/views/homepage_widgets/RecentBookingsWidget.dart';
>>>>>>> Stashed changes
import 'package:arenago/views/homepage_widgets/RecommendationsWidget.dart';
import 'package:arenago/views/search.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/play_buddies/friendlist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    // There will be widgets in it
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Friends',
      style: optionStyle,
    ),
    Text(
      'Index 2: Search',
      style: optionStyle,
    ),
    Text(
      'Index 3: History',
      style: optionStyle,
    ),
    Text(
      'Index 4: Profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
    });
    if (index == 4) {
      Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const ProfileScreen(),
                    ));
    }
    else if (index == 2) {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const SearchPage(),
                    ));
    }
    else if (index == 1) {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const PlayBuddiesPage(),
                    ));
    }
    else if (index == 0) {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const HomePage(),
                    ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArenaGo'),
          automaticallyImplyLeading: false, // This removes the back button
      ),
      body: const Column(
        children: [
          //here, we will have recent booking widget after booking is done
          RecentBookingsWidget(),
          SizedBox(height: 4.0),
          Divider(),
          Text(
            'Top Recommendations',
            //textAlign: TextAlign(textAlign.left),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          RecommendationsWidget(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:dBackgroundColor,
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
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor, 
        onTap: _onItemTapped,
      ),
    );
  }
}

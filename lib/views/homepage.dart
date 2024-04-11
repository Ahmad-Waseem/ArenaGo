import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/TriggerMenu_ProfileButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

Widget _buildRecentsList() {
  // Sample data for recent activities
  final List<String> recentActivities = ["Activity 1", "Activity 2", "Activity 3", "Activity 4"];

  return SizedBox(
    height: 150.0, // Adjust height as needed
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: recentActivities.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(recentActivities[index]),
            ),
          ),
        );
      },
    ),
  );
}


  Widget _buildChoicesList() {
    //placeholder for the vertically scrollable "Choices for you" list
    return Expanded(
      child: ListView.builder(
        itemCount: 20, // Number of items in the list
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Choice ${index + 1}'),
            subtitle: Text('Description for Choice ${index + 1}'),
            // Add onTap if needed
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
    });
    if (index == 4) {
      showModalBottomSheet(
        context: context,
        builder: (context) => ProfileMenu(
          onToggle: () { // Handle menu toggle here
            // Your logic to close the menu
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArenaGo'),
      ),
      body: Column(
        children: [
          _buildRecentsList(), //horizontally swipable "Recents" list
          Text(
            'Choices for you', // Heading for the "Choices for you" list
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          _buildChoicesList(), //vertically scrollable "Choices for you" list
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

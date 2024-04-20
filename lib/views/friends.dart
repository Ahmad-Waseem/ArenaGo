import 'package:arenago/views/ProfileScreen.dart';
import 'package:arenago/views/homepage.dart';
import 'package:arenago/views/search.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/TriggerMenu_ProfileButton.dart';



class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  _FriendsPageState createState() => _FriendsPageState();

}

class _FriendsPageState extends State<FriendsPage> {
  int _selectedIndex = 1;




Widget _buildChoicesList() {
  // Placeholder for the vertically scrollable "Choices for you" list
  return Expanded(
    child: ListView.builder(
      itemCount: 12, // Number of items in the list
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/logo.png'), // Replace with your image asset
          ),
          title: Text('Friend ${index + 1}'),
          subtitle: const Text('Some Cringy description for everyone'),
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
                      builder: (context) => const FriendsPage(),
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
      ),
      body: Column(
        children: [
          const Text(
            'Friends', // Heading for the "Choices for you" list
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

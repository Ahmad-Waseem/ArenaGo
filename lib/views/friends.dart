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
  bool isAdded = true;
  String searchText = "";



Widget _buildFriendsList() {
  // Placeholder for the vertically scrollable "Choices for you" list
  List<String> addedFriends = [
    'luffy',
    'messi',
    'gracie',
  ];
  List<String> filteredAddedFriends = addedFriends.where((friend) {
    return friend.toLowerCase().contains(searchText.toLowerCase());
  }).toList();

  return Expanded(
    child: ListView.builder(
      itemCount: filteredAddedFriends.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/logo.png'), // Replace with your image asset
          ),
          title: Text(filteredAddedFriends[index]),
          subtitle: const Text('Some Cringy description for everyone'),
          trailing: const Icon(Icons.check_circle, color: Colors.green),

          // Add onTap if needed
        );
      },
    ),
  );
}


Widget _buildNonFriendsList() {
  List<String> nonAddedFriends = [
    'hamza',
    'taytoman',
    'luffy',
  ];

  List<String> filteredNonAddedFriends = nonAddedFriends.where((notFriend) {
    return notFriend.toLowerCase().contains(searchText.toLowerCase());
  }).toList();

  return Expanded(
    child: ListView.builder(
      itemCount: filteredNonAddedFriends.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/logo.png'), // Replace with your image asset
          ),
          title: Text(filteredNonAddedFriends[index]),
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
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: Column(
        children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            elevation: 10.0,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                //contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Perform search operation based on the input value
                setState(() {
                              if (value.isEmpty) {
                                isAdded = false; // Set isAdded to true when the search bar is empty
                              } 
                              else {
                                isAdded = true; // Set isAdded to false when there is text in the search bar
                              }
                              searchText = value;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

          // const Text(
          //   'Friends', // Heading for the "Choices for you" list
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          // if isAdded is false then only the added friends will show
          isAdded ? _buildFriendsList() : 
          _buildFriendsList(),
          _buildNonFriendsList()

          
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
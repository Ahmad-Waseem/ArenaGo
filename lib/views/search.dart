import 'package:arenago/views/ProfileScreen.dart';
import 'package:arenago/views/friends.dart';
import 'package:arenago/views/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/TriggerMenu_ProfileButton.dart';
import 'package:flutter/widgets.dart';

import 'package:arenago/views/play_buddies/friendlist.dart';

import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

//////////////////
class Friend {
  final String friendId;
  final String username;

  Friend({required this.friendId, required this.username});
}
////////////

class _SearchPageState extends State<SearchPage> {
  // List<String> _friendsList = []; // List to store fetched friends
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<String> friendIds = [];
  List<String> friendNames = [];
  List<Friend> friendList = [];

  List<String> p_selectedFriends = []; // List to store selected friends

  List<Friend> _selectedFriends = []; ////////////^
  final friendsL = <Friend>[]; ///////////////////<

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<List<Friend>> getFriends(String userId) async {
    final DatabaseReference friendsRef = _database.ref('friends/$userId');
    final DataSnapshot snapshot = await friendsRef.get();

    if (snapshot.exists) {
      final Map<dynamic, dynamic>? data =
          snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        List<Friend> friendList = [];
        for (var entry in data.entries) {
          final String friendId = entry.key as String;
          final String username = await _getUsername(friendId);
          if (username.isNotEmpty) {
            friendList.add(Friend(friendId: friendId, username: username));
          }
        }
        return friendList;
      }
    }

    return [];
  }

  Future<String> _getUsername(String userId) async {
    final DataSnapshot userSnapshot =
        await _database.ref('users/$userId/username').get();
    if (userSnapshot.exists) {
      return userSnapshot.value as String;
    }
    return '';
  }

  void _loadData() async {
    final friendInstances = await getFriends(currentUserId);
    setState(() {
      friendList = friendInstances;
      friendIds = friendList.map((friend) => friend.friendId).toList();
      friendNames = friendList.map((friend) => friend.username).toList();
    });
  }

  Future<User> _getUserById(String userId) async {
    // Fetch user data from the Realtime Database and return a User object
    final snapshot = await FirebaseDatabase.instance.ref('users/$userId').get();
    final userData = snapshot.value as Map<dynamic, dynamic>;
    return User(
        id: userId,
        username: userData['username'],
        profilePic: userData['profilePic']);
  }

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 4) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ));
    } else if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SearchPage(),
      ));
    } else if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const PlayBuddiesPage(),
      ));
    } else if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(
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
          Container(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),

            //width: double.infinity,
            decoration: BoxDecoration(
              color: loginOutlinecolor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Arena Name',
                  prefixIcon: Icon(Icons.stadium_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(200.0),
                    borderSide: const BorderSide(color: loginOutlinecolor),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  filled: true, // Set filled to true
                  fillColor: Colors
                      .white, // Set the color inside the text box to white
                ),
              ),
              const SizedBox(height: 6.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Location',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide:
                              const BorderSide(color: loginOutlinecolor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                        filled: true, // Set filled to true
                        fillColor: Colors
                            .white, // Set the color inside the text box to white
                      ),
                    ),
                  ),
                  SizedBox(width: 0.0),
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Max Distance',
                        prefixIcon: Icon(Icons.route_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide:
                              const BorderSide(color: loginOutlinecolor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                        filled: true, // Set filled to true
                        fillColor: Colors
                            .white, // Set the color inside the text box to white
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      // optional flex property if flex is 1 because the default flex is 1
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                200.0), // Adjust as desired
                          ),
                          hintText: 'Arena Type',
                          //prefixIcon: Icon(Icons.sports_cricket),
                        ),
                        items: <String>[
                          'Futsal',
                          'Football',
                          'Cricket(Outdoor)',
                          'D'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      )),
                  const SizedBox(width: 0.0),
                  Expanded(
                    // optional flex property if flex is 1 because the default flex is 1
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Max Price',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide:
                              const BorderSide(color: loginOutlinecolor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                        filled: true, // Set filled to true
                        fillColor: Colors
                            .white, // Set the color inside the text box to white
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  prefixIcon: Icon(Icons.sports_soccer_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(200.0),
                    borderSide: const BorderSide(color: loginOutlinecolor),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  filled: true, // Set filled to true
                  fillColor: Colors
                      .white, // Set the color inside the text box to white
                ),
              ),
              const SizedBox(height: 15.0),


///////////////// func 2
              const Center(
                  child: Text(
                "Select Friends to search for an Arena convenient to all",
                style: TextStyle(
                  fontSize: 14.6,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              )),

              const SizedBox(height: 6.0),

              ////////////func 1
              DropdownButtonFormField<String>(
                value: p_selectedFriends.isNotEmpty
                    ? p_selectedFriends.first
                    : null,
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                                       
                      if (p_selectedFriends.contains(newValue)) {
                        p_selectedFriends.remove(newValue);
                      } else {
                        p_selectedFriends.add(newValue);
                      }
                    }
                  });
                },
                items: friendList.map((Friend friend) {
                  return DropdownMenuItem<String>(
                    value: friend.friendId,       // use their ids
                    child: Text(friend.username), // Display friend names
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(200.0), // Adjust as desired
                  ),
                  labelText: 'Select Friends',
                  prefixIcon: Icon(Icons.people),
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 6),
              Wrap(
                children: p_selectedFriends.map((friendId) {
                  final selectedFriend = friendList
                      .firstWhere((friend) => friend.friendId == friendId);
                  return Chip(
                    label:
                        Text(selectedFriend.username), // Display friend names
                    onDeleted: () =>
                        setState(() => p_selectedFriends.remove(friendId)),
                  );
                }).toList(),
              ),
//////////////////
              const SizedBox(height: 15.0),
            ]),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => .......));*/
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: loginOutlinecolor,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child:
                  const Text("Search", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: dBackgroundColor,
        unselectedItemColor: loginOutlinecolor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Search User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Arena',
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
        selectedItemColor: loginOutlinecolor,
        onTap: _onItemTapped,
      ),
    );
  }
}

/*
Widget _buildFriendsDropdown() {
    return StreamBuilder(
      stream: _fetchFriendList(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No friends available');
        } else {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(200.0),
              ),
              hintText: 'Select Friends',
              //prefixIcon: Icon(Icons.person_add),
            ),
            items: snapshot.data!.map((String friend) {
              return DropdownMenuItem<String>(
                value: friend,
                child: Text(friend),
              );
            }).toList(),
            onChanged: (String? selectedFriend) {
              setState(() {
                if (selectedFriend != null) {
                  if (_selectedFriends.contains(selectedFriend)) {
                    _selectedFriends.remove(selectedFriend);
                  } else {
                    _selectedFriends.add(selectedFriend);
                  }
                }
              });
            },
            value: _selectedFriends.isNotEmpty ? _selectedFriends[0] : null,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 36.0,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            dropdownColor: Colors.white,
            // Allow selecting multiple options
            //multiSelect: true,
          );
        }
      },
    );
  }

  Stream<List<String>> _fetchFriendList() {
    // Replace this with your logic to fetch friend list from Firebase
    // For demonstration, returning a dummy list of friends
    return Stream.value(['Friend 1', 'Friend 2', 'Friend 3']);
  }
}



*/
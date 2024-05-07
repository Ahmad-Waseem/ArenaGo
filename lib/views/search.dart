import 'package:arenago/views/ProfileScreen.dart';
import 'package:arenago/views/friends.dart';
import 'package:arenago/views/homepage.dart';
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

class _SearchPageState extends State<SearchPage> {
  List<String> _friendsList = []; // List to store fetched friends
  List<String> _selectedFriends = []; // List to store selected friends

  @override
  void initState() {
    super.initState();
    _fetchFriendList(); // Fetch friends list when the page is initialized
  }

  void _fetchFriendList() {
    // Implement logic to fetch friends list from Firebase or any other data source
    // Here, we are using a dummy list as an example
    setState(() {
      _friendsList = [
        'Friend 1',
        'Friend 2',
        'Friend 3',
        'Friend 4',
      ];
    });
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
                  labelText: 'Srart Time',
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

              Center(
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

//friend selection dropdown menu
//////////////////
              DropdownButtonFormField<String>(
                value:
                    _selectedFriends.isNotEmpty ? _selectedFriends.first : null,
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      if (_selectedFriends.contains(newValue)) {
                        _selectedFriends.remove(newValue);
                      } else {
                        _selectedFriends.add(newValue);
                      }
                    }
                  });
                },
                items: _friendsList.map((String friend) {
                  return DropdownMenuItem<String>(
                    value: friend,
                    child: Text(friend), // Assuming you display friend names
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
                children: _selectedFriends
                    .map((friend) => Chip(
                          label:
                              Text(friend), // Assuming you display friend names
                          onDeleted: () =>
                              setState(() => _selectedFriends.remove(friend)),
                        ))
                    .toList(),
              ),

              //],
/////////////////
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
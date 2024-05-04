import 'package:arenago/views/ProfileScreen.dart';
import 'package:arenago/views/add_arena.dart';
import 'package:arenago/views/friends.dart';
import 'package:arenago/views/homepage.dart';
import 'package:arenago/views/owner_homepage.dart';
import 'package:arenago/views/owner_profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/TriggerMenu_ProfileButton.dart';
import 'package:flutter/widgets.dart';

class OwnerSearchPage extends StatefulWidget {
  const OwnerSearchPage({super.key});

  @override
  _OwnerSearchPageState createState() => _OwnerSearchPageState();
}

class _OwnerSearchPageState extends State<OwnerSearchPage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 4) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const OwnerProfileScreen(),
      ));
    } else if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const OwnerSearchPage(),
      ));
    } else if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddArenaView(),
      ));
    } else if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const OwnerHomePage(),
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
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),

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
              const SizedBox(width: 3.0),
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
              const SizedBox(width: 3.0),
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
              const SizedBox(width: 3.0),
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
            ]),
          ),
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
            icon: Icon(Icons.stadium),
            label: 'Add Arena',
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

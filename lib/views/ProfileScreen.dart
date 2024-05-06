
import 'package:arenago/views/homepage.dart';
import 'package:arenago/views/login_view.dart';
import 'package:arenago/views/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/UpdateProfileView.dart';
import 'package:arenago/views/gmaps/LoadMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:arenago/views/login_helpers/forgot_pw.dart';
import 'package:arenago/views/play_buddies/friendlist.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _usernameController = "";
  var _phoneNumberController = "";
  var _addressNumberController = "";
  LatLng? _location = null;
  var _profilePic = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      String id = user!.uid;
      debugPrint('this user $id');

      final userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
      userRef.onValue.listen((event) async {
        var dataSnapshot = event.snapshot;
        var data = dataSnapshot.value as Map?;
        _usernameController = data?['username'] ?? '';
        _phoneNumberController = data?['phone'] ?? '';
        _addressNumberController = data?['address'] ?? '';
        _location = LatLng(
          data?['location']['latitude'] as double,
          data?['location']['longitude'] as double,
        );
        debugPrint(
            '---------++++++++++++++++++++***********************$_location');
        setState(() {
          _location = LatLng(
            data?['location']['latitude'] as double,
            data?['location']['longitude'] as double,
          );
          _profilePic = data!['profilePic'].toString();
        });
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  int _selectedIndex = 4;

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

//----------------------------------> Bottom Navbar Start
  //light color scheme
  final Color primaryColor = Colors.blue; // Replace kprimary color
  final Color darkColor = Colors.black; // Text color, dbg button

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

//----------------------------------> Bottom Navbar End

  // @override
  // _ProfileScreenState createState() => _ProfileScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: Theme.of(context).textTheme.headline4),
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// profile
              Container(
                padding: const EdgeInsets.fromLTRB(100.0, 15.0, 100.0, 15.0),
                decoration: BoxDecoration(
                  color: loginOutlinecolor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _profilePic.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(_profilePic),
                                )
                              : const CircleAvatar(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                        )),
                    const SizedBox(height: 10),
                    Center(
                        child: Text(
                      "@" + _usernameController,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ))
                  ],
                ),
              ),

              const SizedBox(height: 10),

              //Text(tProfileHeading, style: Theme.of(context).textTheme.headline4),
              //Text(tProfileSubHeading, style: Theme.of(context).textTheme.bodyText2),

              const SizedBox(height: 20),

              /// -- BUTTON

              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpdateProfileView()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: loginOutlinecolor,
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: Text("Edit Profile",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpdateProfileView()));*/
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: loginOutlinecolor,
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: Text("Billing Details",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ]),

              const SizedBox(height: 0),

              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: loginOutlinecolor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: Text("Reset Password",
                      style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 15),

              /*const Divider(),

              const SizedBox(height: 10),

// -- MENU
              ListTile(
                leading: Icon(Icons.payment),
                title: Center(child: Text("Billing Details")),
                onTap: () {},
              ),  */

//THIS WILl bE USED in OWNERS COPY
// ListTile(
//   leading: Icon(Icons.supervised_user_circle),
//   title: Text("User Management"),
//   onTap: () {},
// ),

              Divider(),

              Container(
                //decoration: BoxDecoration( borderRadius: BorderRadius.circular(50)),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: const Text(
                            textAlign: TextAlign.center, "Current Location:")),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: SizedBox(
                          height: 200,
                          child: _location == null
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : LoadMap(initialPosition: _location),
                        ))
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Divider(),

              ListTile(
                title: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                          width:
                              8), // Add some spacing between the icon and text
                      Text("Logout", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("LOGOUT", style: TextStyle(fontSize: 20)),
                        content: Text("Are you sure, you want to Logout?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              signOut();

                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const LoginView(),
                              ));
                            }, //onPressed: ,//() //=> //logout(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              side: BorderSide.none,
                            ),
                            child: Text("Yes"),
                          ),
                          OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("No")),
                        ],
                      );
                    },
                  );
                },
              ),

              ListTile(
                title: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info),
                      SizedBox(
                          width:
                              8), // Add some spacing between the icon and text
                      Text("Info"),
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),

//----------------------------------> Bottom navbar starts again
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

//------------------------------------->Bottom navbar ends again
Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('User signed out successfully.');
  } catch (e) {
    print('Error signing out: $e');
  }
}

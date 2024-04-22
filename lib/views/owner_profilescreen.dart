import 'package:arenago/views/add_arena.dart';
import 'package:arenago/views/friends.dart';
import 'package:arenago/views/homepage.dart';
import 'package:arenago/views/login_view.dart';
import 'package:arenago/views/owner_homepage.dart';
import 'package:arenago/views/owner_login_view.dart';
import 'package:arenago/views/owner_search.dart';
import 'package:arenago/views/search.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/UpdateProfileView.dart';
import 'package:arenago/views/gmaps/LoadMap.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  _OwnerProfileScreenState createState() => _OwnerProfileScreenState();
}


class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
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

  @override
  _OwnerProfileScreenState createState() => _OwnerProfileScreenState();

  //light color scheme
  final Color primaryColor = Colors.blue; // Replace kprimary color
  final Color darkColor = Colors.black; // Text color, dbg button


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
    });
    if (index == 4) {
      Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const OwnerProfileScreen(),
                    ));
    }
    else if (index == 2) {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const OwnerSearchPage(),
                    ));
    }
    else if (index == 1) {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => AddArenaView(),
                    ));
    }
    else if (index == 0) {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const OwnerHomePage(),
                    ));
    }
  }
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

              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(image: AssetImage('assets/logo.png')),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primaryColor,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              //Text(tProfileHeading, style: Theme.of(context).textTheme.headline4),
              //Text(tProfileSubHeading, style: Theme.of(context).textTheme.bodyText2),

              const SizedBox(height: 20),

              /// -- BUTTON

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileView()));
                  },
            
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, side: BorderSide.none, shape: const StadiumBorder()),
                  child: Text("Edit Profile", style: TextStyle(color: darkColor)),
                ),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 10),



              const SizedBox(height: 10),
// -- MENU

ListTile(
  leading: Icon(Icons.settings),
  title: Text("Settings"),
  onTap: () {},
),

ListTile(
  leading: Icon(Icons.payment),
  title: Text("Billing Details"),
  onTap: () {},
),

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
      
      const Text(textAlign: TextAlign.left, "Current Location:"),
      LoadMap(UniqueKey()),
    ],
  ),
),

// ListTile(
//   leading: Icon(Icons.location_on),
//   title: Text('My Location'),
//   trailing: Container(
//     height: 200,
    
//   ),
// ),

const SizedBox(height: 10),

      ListTile(
        leading: Icon(Icons.info),
        title: Text("Info"),
        onTap: () {},
      ),

      ListTile(
        leading: Icon(Icons.logout),
        title: Text("Logout"),
        textColor: Colors.red,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("LOGOUT", style: TextStyle(fontSize: 20)),
                content: Text("Are you sure, you want to Logout?"),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const OwnerLoginView(),
                    )),//onPressed: ,//() //=> //logout(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                    child: Text("Yes"),
                  ),
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: Text("No")),
                ],
              );
            },
          );
        },
      ),            
    ],
    
          ),
        ),
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
            icon: Icon(Icons.stadium),
            label: 'Add Arena',
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

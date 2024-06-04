import 'package:arenago/views/Modules/userModules/ProfileScreen.dart';
import 'package:arenago/views/P2B_connectorModule/bookingViews/userBookings.dart';
import 'package:arenago/views/Modules/userModules/homepage_widgets/RecentBookingsWidget.dart';
import 'package:arenago/views/Modules/userModules/homepage_widgets/RecommendationsWidget.dart';
import 'package:arenago/views/Modules/userModules/search.dart';
import 'package:arenago/views/Modules/userModules/notifications.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/Modules/userModules/play_buddies/friendlist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 4) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ));
    } else if (index == 3) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotificationsPage(), ///////////
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
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('My Bookings'),
                value: 'myBookings',
              ),
            ],
            onSelected: (value) {
              if (value == 'myBookings') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      UserFieldBookings(), // Navigate to UserFieldBookings widget
                ));
              }
            },
          ),
        ],
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        //mainAxisSize: MainAxisSize.max,
        children: [
          //here, we will have recent booking widget after booking is done

          ///////
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ), // Background color
            child: Column(
              children: [
                RecentBookingsWidget(),
                SizedBox(height: 4.0),
                Divider(),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Top Recommendations',
                      //textAlign: TextAlign(textAlign.left),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ////////////
          SizedBox(height: 8.0),
          RecommendationsWidget(),
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
            label: 'Play Buddies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_rounded),
            label: 'Notifications',
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

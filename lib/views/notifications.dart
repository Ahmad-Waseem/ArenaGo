import 'package:flutter/material.dart';

import 'package:arenago/views/play_buddies/FriendRequestPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:arenago/views/ProfileScreen.dart';
import 'package:arenago/views/homepage.dart';
import 'package:arenago/views/search.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';

import 'package:arenago/views/ProfileScreen.dart';
import 'package:arenago/views/bookingViews/userBookings.dart';
import 'package:arenago/views/homepage_widgets/RecentBookingsWidget.dart';
import 'package:arenago/views/homepage_widgets/RecommendationsWidget.dart';
import 'package:arenago/views/search.dart';
import 'package:arenago/views/notifications.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/play_buddies/friendlist.dart';

import 'package:arenago/views/homepage_widgets/recent_bookings_backend.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final RecentBookingsBackend _backend = RecentBookingsBackend();
  String? currentUserId;
  List<Map<dynamic, dynamic>> _recentBookings = [];
  List<String> _arenaNames = [];
  bool hasBooking = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    _fetchRecentBookings();
  }

  Future<void> _getCurrentUserId() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      String id = user!.uid;
      currentUserId = id;
    } catch (e) {
      debugPrint("Exception: Cannot fetch user id");
    }
  }

  Future<void> _fetchRecentBookings() async {
    final userId = currentUserId;
    hasBooking = false;
    final bookings = await _backend.getUserRecentBookings(userId!);
    final arenaNames = await _fetchArenaNames(bookings);

    setState(() {
      _recentBookings = bookings;
      _arenaNames = arenaNames;
      hasBooking = _recentBookings.isNotEmpty;
    });
  }

  Future<List<String>> _fetchArenaNames(
      List<Map<dynamic, dynamic>> bookings) async {
    List<String> arenaNames = [];
    for (var booking in bookings) {
      final arenaId = booking['arenaId'];
      final snapshot =
          await FirebaseDatabase.instance.ref('ArenaInfo/$arenaId').get();
      if (snapshot.value != null) {
        final arenaData = snapshot.value as Map<dynamic, dynamic>;
        arenaNames.add(arenaData['arena_name']);
      } else {
        arenaNames.add('Anonymous Arena');
      }
    }
    return arenaNames;
  }

  int _selectedIndex = 3;

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
     else if (index == 3) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotificationsPage(), ///////////
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        automaticallyImplyLeading: false,
      ),
      body: hasBooking
          ? ListView.builder(
              itemCount: _recentBookings.length,
              itemBuilder: (context, index) {
                final booking = _recentBookings[index];
                final arenaName = _arenaNames[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(booking['image']),
                  ),
                  title: Text('Booking at $arenaName'),
                  subtitle: Text(
                      'Time Slot: ${booking['selectedTimeSlot']['startTime']} - ${booking['selectedTimeSlot']['endTime']}'),
                  onTap: () {
                    // Handle tap event
                  },
                );
              },
            )
<<<<<<< Updated upstream
          : Center(
              child: Text(
                'No recent notifications',
                style: TextStyle(fontSize: 18),
=======
          :

          //////////////

          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.notifications_none,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
>>>>>>> Stashed changes
              ),
            ),

      ////////////
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

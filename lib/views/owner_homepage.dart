import 'package:arenago/views/add_arena.dart';
import 'package:arenago/views/arenaPage.dart';

import 'package:arenago/views/owner_profilescreen.dart';
import 'package:arenago/views/owner_search.dart';

import 'package:arenago/views/theme.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ArenaInfo {
  final String arenaId;
  final String arenaName;
  final String address;
  final String city;
  final String contact;
  final DateTime date;
  final String endTime;
  final Location location;
  final int price;
  final String startTime;
  final String town;
  final List<String> arenaImages;

  ArenaInfo({
    required this.arenaId,
    required this.arenaName,
    required this.address,
    required this.city,
    required this.contact,
    required this.date,
    required this.endTime,
    required this.location,
    required this.price,
    required this.startTime,
    required this.town,
    required this.arenaImages,
  });
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });
}


class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({Key? key}) : super(key: key);

  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  final arenasRef = FirebaseDatabase.instance.ref().child('ArenaInfo');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();

  int _selectedIndex = 0;

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


  Widget _buildArenaListItem(
      BuildContext context, Animation<double> animation, ArenaInfo arenaInfo) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        elevation: 2.0, // Add a slight elevation for card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0), // Adjust content padding
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              arenaInfo.arenaImages.isNotEmpty
                  ? arenaInfo.arenaImages[0]
                  : 'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              width: 80.0, // Increase image width
              height: 80.0, // Increase image height
            ),
          ),
          title: Text(
            arenaInfo.arenaName,
            style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500), // Adjust text style
          ),
          subtitle: Text(
            'ID: ${arenaInfo.arenaId}',
            style: const TextStyle(
                fontSize: 14.0, color: Colors.grey), // Style for arena ID
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArenaPage(arena: arenaInfo),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ArenaGo'),
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: Column(
          children: [
            const SizedBox(height: 16.0), // Add a little spacing
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0), // Add padding
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Arenas',
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold), // Style for heading
                ),
              ),
            ),
            const SizedBox(height: 8.0), // Add a little spacing
            Expanded(
              // Use Expanded widget for list
              child: FirebaseAnimatedList(
                query:
                    arenasRef.orderByChild('owner_id').equalTo(currentUserId),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  final arenaData = snapshot.value as Map<dynamic, dynamic>;
                  final arenaInfo = ArenaInfo(
                    arenaId: snapshot.key!,
                    arenaName: arenaData['arena_name'] as String,
                    // ... Populate other properties from the data
                    address: arenaData['address'] as String,
                    city: arenaData['city'] as String,
                    contact: arenaData['contact'] as String,
                    date: DateTime.parse(arenaData['date'] as String),
                    endTime: arenaData['end_time'] as String,
                    location: Location(
                      latitude: arenaData['location']['latitude'] as double,
                      longitude: arenaData['location']['longitude'] as double,
                    ),
                    price: arenaData['price'] as int,
                    startTime: arenaData['start_time'] as String,
                    town: arenaData['town'] as String,
                    arenaImages: (arenaData['arena_images'] as List<dynamic>)
                        .map((image) => image as String)
                        .toList(),
                  );

                  return _buildArenaListItem(context, animation, arenaInfo);
                },
              ),
            ),
            Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align button to bottom right
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 16.0), // Add padding
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddArenaView()), // Assuming AddArenaView is defined
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
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

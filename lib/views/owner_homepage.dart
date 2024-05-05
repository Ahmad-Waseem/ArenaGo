// import 'package:flutter/material.dart';
// import 'package:arenago/views/ProfileScreen.dart';
import 'package:arenago/views/add_arena.dart';
import 'package:arenago/views/arenaPage.dart';
import 'package:arenago/views/friends.dart';
import 'package:arenago/views/owner_profilescreen.dart';
import 'package:arenago/views/owner_search.dart';
import 'package:arenago/views/search.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/TriggerMenu_ProfileButton.dart';
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

// // Simulate API call to fetch arenas (replace with your actual implementation)
// Future<List<ArenaInfo>> fetchArenas() async {
//   // Replace with your API call logic
//   await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
//   return [
//     ArenaInfo(
//       arenaId: "7cc93f33-46f6-42cd-baae-006358d88e36",
//       arenaName: "Arena A",
//       address: "vh",
//       city: "fg",
//       contact: "85",
//       date: DateTime.parse("2024-05-04T23:22:38.908086"),
//       endTime: "8:00 PM",
//       location: Location(latitude: 31.82882274353957, longitude: 75.51695141941309),
//       price: 88,
//       startTime: "8:00 AM",
//       town: "fg",
//       arenaImages: [
//         "https://firebasestorage.googleapis.com/v0/b/arenago-56abc.appspot.com/o/arena_images%2F7cc93f33-46f6-42cd-baae-006358d88e36%2FScreenshot_20240504_170356_com.example.arenago.jpg?alt=media&token=fc710ca8-2bd6-4544-9928-8bb881243cdb"
//       ],
//     ),
//     // Add more arenas if needed
//   ];
// }

// class OwnerHomePage extends StatefulWidget {
//   const OwnerHomePage({super.key});

//   @override
//   _OwnerHomePageState createState() => _OwnerHomePageState();
// }

// class _OwnerHomePageState extends State<OwnerHomePage> {
//   int _selectedIndex = 0;

//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

//   static const List<Widget> _widgetOptions = <Widget>[
//     // There will be widgets in it
//     Text(
//       'Index 0: Home',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 1: Friends',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 2: Search',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 3: History',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 4: Profile',
//       style: optionStyle,
//     ),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (index == 4) {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => const OwnerProfileScreen(),
//       ));
//     } else if (index == 2) {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => const OwnerSearchPage(),
//       ));
//     } else if (index == 1) {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => AddArenaView(),
//       ));
//     } else if (index == 0) {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => const OwnerHomePage(),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ArenaGo'),
//         automaticallyImplyLeading: false, // This removes the back button
//       ),
//       body: FutureBuilder<List<ArenaInfo>>(
//         future: fetchArenas(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final arenas = snapshot.data!;
//             return ListView.builder(
//               itemCount: arenas.length,
//               itemBuilder: (context, index) {
//                 final arena = arenas[index];
//                 return Card(
//                   child: ListTile(
//                     title: Text(arena.arenaName),
//                     subtitle: Text(arena.arenaId),
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ArenaPage(arena: arena),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error fetching arenas'));
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: dBackgroundColor,
//         unselectedItemColor: loginOutlinecolor,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.stadium),
//             label: 'Add Arena',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history_toggle_off),
//             label: 'History',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_rounded),
//             label: 'Account',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: kPrimaryColor,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({Key? key}) : super(key: key);

  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  final arenasRef = FirebaseDatabase.instance.ref().child('ArenaInfo');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();

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
        )
        );
  }
}

import 'package:arenago/views/Modules/businessModules/arenaPage.dart';
import 'package:arenago/views/Modules/businessModules/bookField.dart';
import 'package:arenago/views/auxilaryPages/homepage.dart';
import 'package:arenago/views/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/Modules/userModules/homepage_widgets/recent_bookings_backend.dart';

class RecentBookingsWidget extends StatefulWidget {
  const RecentBookingsWidget({super.key});

  @override
  _RecentBookingsWidgetState createState() => _RecentBookingsWidgetState();
}

class _RecentBookingsWidgetState extends State<RecentBookingsWidget> {
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
      const SnackBar(
        content: Text("Make Sure a Stable Network connection!"),
        backgroundColor: dangerErrorColor,
      );

      debugPrint("Exception: Cannot fetch user id");
    }
  }

  Future<void> _fetchRecentBookings() async {
    final userId = currentUserId;
    hasBooking = false;
    final bookings = await _backend.getUserRecentBookings(userId!);
    //debugPrint("here is the error");
    final arenaNames = await _fetchArenaNames(bookings);
    //debugPrint("here is the error2--------------------");
    setState(() {
      _recentBookings = bookings;
      _arenaNames = arenaNames;

      if (_recentBookings.isEmpty) {
        setState(() {
          hasBooking = false;
        });
      } else {
        hasBooking = true;
      }
    });
  }

  Future<List<String>> _fetchArenaNames(
      List<Map<dynamic, dynamic>> bookings) async {
    List<String> arenaNames = [];
    for (var booking in bookings) {
      final arenaId = booking['arenaId'];
      //debugPrint('-->$arenaId');
      final snapshot =
          await FirebaseDatabase.instance.ref('ArenaInfo/$arenaId').get();
      if (snapshot.value != null) {
        final arenaData = snapshot.value as Map<dynamic, dynamic>;
        arenaNames.add(arenaData['arena_name']);
        //debugPrint("\n");
        //debugPrint(arenaData['arena_name']);
      } else {
        arenaNames.add('Anonymous Arena'); //arena data is not available
      }
    }
    //debugPrint("\nReturned");

    return arenaNames;
  }

  Future<void> _changeScreen(var booking) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(color: loginOutlinecolor),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    FieldInfo fieldInfo = await _backend.fetchFieldInfo(
        booking['fieldId']); // Implement this method to fetch FieldInfo

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => BookField(
                fieldData: fieldInfo,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !hasBooking
        ? Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: loginOutlinecolor,
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
              ),
              child: const Text("( ･ω･ ?)\nNo recent Bewking",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ))
        : /////////////
        Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(10.0), // Add padding here
              decoration: BoxDecoration(
                color: loginOutlinecolor,
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 0.0, // Border width
                ),
              ),
              child: Column(children: [
                /* const Center(
                  child: Text(
                    'Recent Bookings',
                    //textAlign: TextAlign(textAlign.left),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ), */
                const SizedBox(
                  height: 2.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _recentBookings.length,
                      itemBuilder: (context, index) {
                        final booking = _recentBookings[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: InkWell(
                            onTap: () {
                              _changeScreen(booking);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Colors.grey[200],
                                border: Border.all(
                                  color: Colors.black, // Border color
                                  width: 0.0, // Border width
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Rounded corners
                                        child: SizedBox(
                                          width: 80,
                                          height: 130,
                                          child: Image.network(
                                            booking['image'],
                                            fit: BoxFit
                                                .fill, // Fit the image to the box
                                          ),
                                        ),
                                      ),
                                    ),

                                    Text(
                                      _arenaNames[index],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //const SizedBox(height: 8.0),
                                    // Text('${booking['start_time']} - ${booking['end_time']}'),
                                    //const SizedBox(height: 8.0),
                                    // Text('Price: \$${booking['price'].toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]),
            ));
    //////////
  }
}

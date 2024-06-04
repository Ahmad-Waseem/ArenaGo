import 'package:arenago/views/P2B_connectorModule/bookingViews/bookingsClass.dart';
import 'package:arenago/views/dbClasses/userInfo.dart';

import 'package:arenago/views/Modules/ownerModules/owner_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class OwnerFieldBookings extends StatefulWidget {
  final List<ArenaInfo> arenas;

  const OwnerFieldBookings({Key? key, required this.arenas}) : super(key: key);

  @override
  State<OwnerFieldBookings> createState() => _OwnerFieldBookingsState();
}

class _OwnerFieldBookingsState extends State<OwnerFieldBookings> {
  final bookingsRef = FirebaseDatabase.instance.ref().child('Bookings');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<AGUser> users = []; // List of users

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  void _fetchUserData() {
  FirebaseDatabase.instance
      .ref()
      .child('users')
      .onValue
      .listen((event) {
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        users = data.entries.map((entry) {
          final userData = entry.value as Map<dynamic, dynamic>;
          return AGUser(
            uid: entry.key,
            username: userData['username'],
            address: userData['address'],
            phone: userData['phone'],
            profilePic: userData['profilePic'],
            latitude: userData['location']['latitude'],
            longitude: userData['location']['longitude'],
          );
        }).toList();
      });
    }
  });
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Field Bookings'),
      ),
      body: FirebaseAnimatedList(
        query: bookingsRef.orderByChild('arenaId').startAt(widget.arenas.first.arenaId).endAt(widget.arenas.last.arenaId),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          final bookingData = snapshot.value as Map<dynamic, dynamic>;
          final bookingInfo = BookingInfo(
            bookingId: snapshot.key!,
            arenaId: bookingData['arenaId'] as String,
            fieldId: bookingData['fieldId'] as String,
            image: bookingData['image'] as String,
            price: bookingData['price'] as int,
            timestamp: DateTime.parse(bookingData['timestamp'] as String),
            selectedTimeSlot: SelectedTimeSlot(
              startTime: DateTime.parse(
                  bookingData['selectedTimeSlot']['startTime'] as String),
              endTime: DateTime.parse(
                  bookingData['selectedTimeSlot']['endTime'] as String),
            ),
            userId: bookingData['userId'] as String,
          );

          // Filter bookings based on the arenaId
          // final matchingArena = widget.arenas.firstWhere(
          //   (arena) => arena.arenaId == bookingInfo.arenaId,
          //   orElse: () => null,
          // );
          final matchingArena = widget.arenas.firstWhere(
            (arena) => arena.arenaId == bookingInfo.arenaId,
          );
          if (matchingArena != null) {
            // Return a widget to display the booking
            return _buildBookingListItem(bookingInfo);
          } else {
            // If the booking's arenaId doesn't match any arena in the list, return an empty container
            return Container();
          }
        },
      ),
    );
  }
Widget _buildBookingListItem(BookingInfo bookingInfo) {
  String slotTime = 'Unknown';

  // Check if selectedTimeSlot is not null before accessing its properties
  if (bookingInfo.selectedTimeSlot != null) {
    String formattedStartTime =
        '${bookingInfo.selectedTimeSlot.startTime.hour.toString().padLeft(2, '0')}:${bookingInfo.selectedTimeSlot.startTime.minute.toString().padLeft(2, '0')}';
    String formattedEndTime =
        '${bookingInfo.selectedTimeSlot.endTime.hour.toString().padLeft(2, '0')}:${bookingInfo.selectedTimeSlot.endTime.minute.toString().padLeft(2, '0')}';
    slotTime = '$formattedStartTime - $formattedEndTime';
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromARGB(255, 190, 190, 190),
          width: 1.0,
        ),
      ),
      child: ListTile(
        title: Text(
          'Slot Booked: $slotTime',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Highlight the title
            fontSize: 16, // Adjust font size as needed
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Field ID: ${bookingInfo.fieldId}'),
            Text(
              'Booked By: ${bookingInfo.userId}',
              style: TextStyle(
                color: Colors.grey[700], // Dim the color of the subtitle
              ),
            ),
            SizedBox(height: 4), // Add some spacing
            Text(
              'Price: ${bookingInfo.price}',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Highlight the price
                fontSize: 14, // Adjust font size as needed
                color: Colors.green, // Change color of the price
              ),
            ),
          ],
        ),
        // Add more details as needed
      ),
    ),
  );
}



}

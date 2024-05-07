import 'package:arenago/views/bookingViews/bookingsClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class UserFieldBookings extends StatefulWidget {
  @override
  State<UserFieldBookings> createState() => _UserFieldBookingsState();
}

class _UserFieldBookingsState extends State<UserFieldBookings> {
  final bookingsRef = FirebaseDatabase.instance.ref().child('Bookings');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Bookings'),
      ),
      body: FirebaseAnimatedList(
        query: bookingsRef.orderByChild('userId').equalTo(currentUserId),
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

          return _buildBookingListItem(bookingInfo);
        },
      ),
    );
  }

  Widget _buildBookingListItem(BookingInfo bookingInfo) {
    String slotTime = 'Unknown';

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
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Field ID: ${bookingInfo.fieldId}'),
              SizedBox(height: 4),
              Text(
                'Price: ${bookingInfo.price}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

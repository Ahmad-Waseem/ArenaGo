import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RecentBookingsBackend {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  
  // Fetch bookings from the 'bookings' collection for Booking Booking Fields
  Future<List<Map<dynamic, dynamic>>> getUserRecentBookings(String userId) async 
  {
    debugPrint("Getting Recent books");
    final DatabaseReference arenaInfoRef = _database.ref('Bookings'); //make booking
    final DataSnapshot snapshot = await arenaInfoRef.orderByChild('timestamp').limitToFirst(20).get();
    debugPrint('---------????$userId');
    final List<Map<dynamic, dynamic>> recentBookings = [];

    for (final DataSnapshot data in snapshot.children)
    {
      Map<dynamic, dynamic> bookingData = data.value as Map<dynamic, dynamic>;

      if (bookingData['userId'] == userId) {
        recentBookings.add(bookingData);
      }
    }

    return recentBookings;
  }
}
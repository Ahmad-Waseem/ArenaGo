import 'package:arenago/views/Modules/businessModules/arenaPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RecentBookingsBackend {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Fetch bookings from the 'bookings' collection for Booking Booking Fields
  Future<List<Map<dynamic, dynamic>>> getUserRecentBookings(
      String userId) async {
    debugPrint("Getting Recent books");
    final DatabaseReference arenaInfoRef =
        _database.ref('Bookings'); //make booking
    final DataSnapshot snapshot =
        await arenaInfoRef.orderByChild('timestamp').limitToFirst(20).get();
    //debugPrint('---------????$userId');
    final List<Map<dynamic, dynamic>> recentBookings = [];

    for (final DataSnapshot data in snapshot.children) {
      Map<dynamic, dynamic> bookingData = data.value as Map<dynamic, dynamic>;

      if (bookingData['userId'] == userId) {
        if (!recentBookings
            .any((booking) => booking['fieldId'] == bookingData['fieldId'])) {
          recentBookings.add(bookingData);
        }
      }
    }

    return recentBookings;
  }

  Future<FieldInfo> fetchFieldInfo(String fieldId) async {
    final DatabaseReference fieldInfo = _database.ref('FieldInfo/$fieldId');
    final DataSnapshot snapshot = await fieldInfo.get();
    debugPrint('---------       1');
    if (snapshot.exists) {
      final Map<dynamic, dynamic> fieldData =
          snapshot.value as Map<dynamic, dynamic>;
      debugPrint('---------       2');
      debugPrint('---------       3');

      debugPrint('---------       4');

      // Create FieldInfo object
      final FieldInfo fieldInfo = FieldInfo(
        fieldId: fieldId,
        arenaId: fieldData['arenaId'],
        availableMaterial: fieldData['availableMaterial'],
        basePrice: fieldData['basePrice'],
        fieldType: fieldData['fieldType'],
        fieldImages: (fieldData['field_images'] as List<dynamic>)
            .map((image) => image as String)
            .toList(),
        groundType: fieldData['groundType'],
        length: fieldData['length'],
        peakPrice: fieldData['peakPrice'],
        price: fieldData['price'],
        timeSlots: (fieldData['timeSlots'] as List<dynamic>)
            .map((slot) => TimeSlot(
                  startTime: DateTime.parse(slot['startTime']),
                  endTime: DateTime.parse(slot['endTime']),
                ))
            .toList(),
        width: fieldData['width'],
      );
      debugPrint('---------       5');
      return fieldInfo;
    } else {
      debugPrint('---------       0');
      throw Exception('Field data not found');
    }
  }
}

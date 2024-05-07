import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';



// Call this function in new Home...
class TempHomePagebackend
{
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Fetch bookings from the 'bookings' collection for Booking Booking Fields
  Future<List<Map<dynamic, dynamic>>> getUserRecentBookings(String userId) async 
  {
    final DatabaseReference arena = _database.ref('bookings'); //make booking
    final DataSnapshot snap = await arena.orderByChild('userid').equalTo(userId).limitToLast(4).get();

    final List<Map<dynamic, dynamic>> recentBookings = [];
    
    
    for (final DataSnapshot data in snap.children) 
    {
      recentBookings.add(data.value as Map<dynamic, dynamic>);
    }

    return recentBookings;
  }

}
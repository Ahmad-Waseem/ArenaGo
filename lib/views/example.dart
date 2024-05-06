import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';



// Call this function in new Home...
class TempHomePagebackend
{
  final FirebaseDatabase _database = FirebaseDatabase.instance;

 Future<List<Map<String, dynamic>>> getAvailableFields() async {
    final DatabaseReference fieldInfoRef = _database.ref('field_info');
    final DataSnapshot snapshot = await fieldInfoRef.get();

    final List<Map<String, dynamic>> availableFields = [];
    for (final DataSnapshot data in snapshot.children) {
      final Map<String, dynamic> fieldInfo = data.value as Map<String, dynamic>;
      // Check if the field has available timeslots and add it to the list
      // if isFieldAvailable?(fieldInfo)
      //   do: availableFields.add(fieldInfo);

    }

    return availableFields;
  }

    Future<void> updateFieldPrices() async {
    final DatabaseReference fieldInfoRef = _database.ref('field_info');
    final DataSnapshot snapshot = await fieldInfoRef.get();

    for (final DataSnapshot data in snapshot.children) {
      final Map<String, dynamic> fieldInfo = data.value as Map<String, dynamic>;
      final String fieldId = data.key!;

      // Calculate the new price based on the surge pricing logic
      //final double newPrice = surge_price_calculator

      // Update the field price to show user
      //await fieldInfoRef.child(fieldId).update({'temp_price': newPrice});
    }

  }
  
  
  

    
  
}
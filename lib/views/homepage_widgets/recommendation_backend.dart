import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class RecommendationsBackend {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Fetch the available fields from the 'FieldInfo' collection
  Future<List<Map<dynamic, dynamic>>> getAvailableFields() async 
  {
    final DatabaseReference fieldInfoRef = _database.ref('FieldInfo');
    final DataSnapshot snapshot = await fieldInfoRef.get();
    debugPrint("here is the error");
    final List<Map<dynamic, dynamic>> availableFields = [];
    debugPrint("here is the error=======2");
    for (final DataSnapshot data in snapshot.children) 
    {
      final Map<dynamic, dynamic> fieldInfo = data.value as Map<dynamic, dynamic>;
      //if the field has available timeslots and add it to the list
      // if (isFieldAvailable(fieldInfo)) 

        //surge pricing logic
        // final double newPrice = calculateSurgePrice(fieldInfo);
        // fieldInfo['price'] = newPrice;
        availableFields.add(fieldInfo);
        debugPrint("here is the error=======3");
      
    }

    return availableFields;
  }

  // Check if a field has available timeslots
  bool isFieldAvailable(Map<String, dynamic> fieldInfo) 
  {
    
    return true;
  }

  //implement the surge pricing logic
  int calculateSurgePrice(Map<String, dynamic> fieldInfo) {
    final int basePrice = fieldInfo['basePrice'];
    final int peakPrice = fieldInfo['peakPrice'];

    //fetch the available fields within a 5km radius
    final List<Map<String, dynamic>> nearbyFields = _getNearbyFields(fieldInfo);
    final int totalFields = nearbyFields.length;
    final int unbookedFields = _getUnbookedFields(nearbyFields);

    //surge pricing logic
    final double surgePercentage = (unbookedFields / totalFields) * 100;
    if (surgePercentage >= 75) 
    {
      int temp_price = max(fieldInfo['price'], peakPrice);
      return max(basePrice, temp_price);
    } 
    else if (surgePercentage <= 25) 
    {
      int temp_price = min(fieldInfo['price'], peakPrice);
      return min(basePrice, temp_price);
    } 
    else 
    {
      return fieldInfo['price'];
    }
  }


  List<Map<String, dynamic>> _getNearbyFields(Map<String, dynamic> fieldInfo) {
    //for fields in fieldinfo.map.get, use latlon equilidean, add field in nearby fields
    return [];
  }

  //count the number of unbooked fields in the nearby fields
  int _getUnbookedFields(List<Map<String, dynamic>> nearbyFields) {
    int unbookedCount = 0;
    for (final field in nearbyFields) {
      if (isFieldAvailable(field)) {
        unbookedCount++;
      }
    }
    return unbookedCount;
  }
}
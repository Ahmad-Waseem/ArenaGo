import 'dart:math';
import 'package:arenago/views/arenaPage.dart';
import 'package:arenago/views/bookField.dart';
import 'package:arenago/views/homepage_widgets/recommendation_backend.dart';
import 'package:arenago/views/search.dart';
import 'package:arenago/views/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  final String? arenaName;
  final double? maxDistance;
  final DateTime? startTime;
  final double? maxPrice;
  final List<String>? friendIds;

  SearchResult({
    Key? key,
    this.arenaName,
    this.maxDistance,
    this.startTime,
    this.maxPrice,
    this.friendIds,
  }) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<Map<dynamic, dynamic>> _filteredFields = [];
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final RecommendationsBackend _backend = RecommendationsBackend();
  List<String> _arenaNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<List<Map<dynamic, dynamic>>> getFieldsData() async {
    final DatabaseReference fieldRef =
        FirebaseDatabase.instance.ref('FieldInfo');
    final DataSnapshot snapshot = await fieldRef.get();

    if (snapshot.exists) {
      final Map<dynamic, dynamic>? data =
          snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Map<dynamic, dynamic>> fieldsList = data as List<Map>;

        fieldsList.shuffle();

        return fieldsList.length > 20 ? fieldsList.sublist(0, 20) : fieldsList;
      }
    }

    return [];
  }

  Future<void> _fetchSearchResults() async {
    try {
      var filteredFields;
      if (widget.arenaName != "") {
        filteredFields = await _fetchFieldsFromArenaName(widget.arenaName);
      } else {
        filteredFields = await getFieldsData();
      }
      if (widget.maxPrice != -1) {
        filteredFields =
            await _filterFieldsByMaxPrice(filteredFields, widget.maxPrice);
      }
      if (widget.maxPrice != -1) {
        filteredFields =
            await _filterFieldsByMaxPrice(filteredFields, widget.maxPrice);
      }
      if (widget.maxDistance != -1) {
        filteredFields =
            await _filterFieldsByDistance(filteredFields, widget.maxDistance);
      }
      if (widget.friendIds != null) {
        filteredFields =
            await _sortFieldsByDistance(filteredFields, widget.friendIds);
      }

      setState(() async {
        _filteredFields = filteredFields;
        _arenaNames = await _fetchArenaNames(_filteredFields);
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<dynamic, dynamic>>> _fetchFieldsFromArenaName(
      String? arenaName) async {
    List<Map<dynamic, dynamic>> fields = [];

    if (arenaName != null) {
      final arenaSnapshot = await _database
          .ref('ArenaInfo')
          .orderByChild('arena_name')
          .equalTo(arenaName)
          .get();

      if (arenaSnapshot.exists) {
        final Map<dynamic, dynamic>? arenaData =
            arenaSnapshot.value as Map<dynamic, dynamic>?;

        if (arenaData != null) {
          final List<String> arenaIds =
              (arenaData.keys.toList()).cast<String>();

          // Fetch fields
          for (String arenaId in arenaIds) {
            final fieldSnapshot = await _database
                .ref('FieldInfo')
                .orderByChild('arena_id')
                .equalTo(arenaId)
                .get();

            if (fieldSnapshot.exists) {
              final Map<dynamic, dynamic>? fieldData =
                  fieldSnapshot.value as Map<dynamic, dynamic>?;

              if (fieldData != null) {
                fields.add(fieldData);
              }
            }
          }
        }
      }
    }

    return fields;
  }

  Future<List<Map<dynamic, dynamic>>> _filterFieldsByStartTime(
      List<Map<dynamic, dynamic>> fields, DateTime? startTime) async {
    if (startTime != null) {
      List<Map<dynamic, dynamic>> filteredFields = [];

      for (Map<dynamic, dynamic> field in fields) {
        final fieldId = field['fieldId'];

        // Fetch bookings for the field
        final bookingSnapshot = await _database
            .ref('Bookings')
            .orderByChild('fieldId')
            .equalTo(fieldId)
            .get();

        if (bookingSnapshot.exists) {
          final Map<dynamic, dynamic>? bookingData =
              bookingSnapshot.value as Map<dynamic, dynamic>?;

          if (bookingData != null) {
            for (var booking in bookingData.values) {
              final selectedTimeSlot = booking['selectedTimeSlot'];

              if (selectedTimeSlot != null) {
                final startTimeString = selectedTimeSlot['startTime'];

                if (startTimeString != null) {
                  final startTimeDateTime = DateTime.parse(startTimeString);

                  if (startTimeDateTime == startTime) {
                    filteredFields.add(field);
                  }
                }
              }
            }
          }
        }
      }

      return filteredFields;
    } else {
      return fields;
    }
  }

  Future<List<Map<dynamic, dynamic>>> _filterFieldsByMaxPrice(
      List<Map<dynamic, dynamic>> fields, double? maxPrice) async {
    if (maxPrice != null) {
      List<Map<dynamic, dynamic>> filteredFields = [];

      for (Map<dynamic, dynamic> field in fields) {
        final basePrice = field['basePrice'] as double?;

        if (basePrice != null && basePrice <= maxPrice) {
          filteredFields.add(field);
        }
      }

      return filteredFields;
    } else {
      return fields;
    }
  }

  Future<List<Map<dynamic, dynamic>>> _filterFieldsByDistance(
      List<Map<dynamic, dynamic>> fields, double? maxDistance) async {
    if (maxDistance != null) {
      List<Map<dynamic, dynamic>> filteredFields = [];

      final FirebaseAuth auth = FirebaseAuth.instance;

      final User? user = await auth.currentUser;
      final String userId = user!.uid;
      for (Map<dynamic, dynamic> field in fields) {
        final String? arenaId = field['arenaId'] as String?;

        if (arenaId != null) {
          final arenaSnapshot =
              await _database.ref('ArenaInfo/$arenaId/location').get();
          final Map<dynamic, dynamic>? arenaLocation =
              arenaSnapshot.value as Map<dynamic, dynamic>?;

          if (arenaLocation != null) {
            final double arenaLatitude = arenaLocation['latitude'] as double;
            final double arenaLongitude = arenaLocation['longitude'] as double;

            final userSnapshot =
                await _database.ref('users/$userId/location').get();
            final Map<dynamic, dynamic>? userLocation =
                userSnapshot.value as Map<dynamic, dynamic>?;

            if (userLocation != null) {
              final double userLatitude = userLocation['latitude'] as double;
              final double userLongitude = userLocation['longitude'] as double;

              final double distance = _calculateDistance(
                  arenaLatitude, arenaLongitude, userLatitude, userLongitude);

              if (distance <= maxDistance) {
                filteredFields.add(field);
                break; // Skip checking with other friends for this field
              }
            }
          }
        }
      }

      return filteredFields;
    } else {
      return fields;
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers
    final double radLat1 = radians(lat1);
    final double radLat2 = radians(lat2);
    final double dLat = radians(lat2 - lat1);
    final double dLon = radians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(radLat1) * cos(radLat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance;
  }

  double radians(double degrees) {
    return degrees * pi / 180;
  }

  Future<List<Map<dynamic, dynamic>>> _sortFieldsByDistance(
      List<Map<dynamic, dynamic>> filteredFields,
      List<String>? FriendIds) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final String uid = user!.uid;

    // Fetch location data for current user
    final currentUserSnapshot =
        await _database.ref('users/$uid/location').get();
    final Map<dynamic, dynamic>? currentUserLocation =
        currentUserSnapshot.value as Map<dynamic, dynamic>?;

    if (FriendIds != null) {
      FriendIds.add(uid);
      final double currentUserLatitude =
          currentUserLocation?['latitude'] as double;
      final double currentUserLongitude =
          currentUserLocation?['longitude'] as double;

      // Calculate distance for each field and friend
      for (Map<dynamic, dynamic> field in filteredFields) {
        final String? arenaId = field['arenaId'] as String?;

        if (arenaId != null) {
          final arenaSnapshot =
              await _database.ref('ArenaInfo/$arenaId/location').get();
          final Map<dynamic, dynamic>? arenaLocation =
              arenaSnapshot.value as Map<dynamic, dynamic>?;

          if (arenaLocation != null) {
            final double arenaLatitude = arenaLocation['latitude'] as double;
            final double arenaLongitude = arenaLocation['longitude'] as double;

            List<double> distances = [];

            for (String friendid in FriendIds) {
              final String userId = friendid;

              final userSnapshot =
                  await _database.ref('users/$userId/location').get();
              final Map<dynamic, dynamic>? userLocation =
                  userSnapshot.value as Map<dynamic, dynamic>?;

              if (userLocation != null) {
                final double userLatitude = userLocation['latitude'] as double;
                final double userLongitude =
                    userLocation['longitude'] as double;

                final double distance = _calculateDistance(
                    arenaLatitude, arenaLongitude, userLatitude, userLongitude);
                distances.add(distance);
              }
            }

            // Calculate total distance for the field
            double totalDistance =
                distances.fold(0, (prev, element) => prev + element);
            field['distance'] = totalDistance;
          }
        }
      }

      // Sort the fields by total distance
      filteredFields.sort((a, b) =>
          (a['distance'] as double).compareTo(b['distance'] as double));

      // Return the first 20 entries if the list is longer than 20
      return filteredFields.length > 20
          ? filteredFields.sublist(0, 20)
          : filteredFields;
    } else {
      return filteredFields;
    }
  }

  Future<List<String>> _fetchArenaNames(
      List<Map<dynamic, dynamic>> fields) async {
    List<String> arenaNames = [];
    for (var field in fields) {
      final arenaId = field['arenaId'];
      debugPrint('-->$arenaId');
      final snapshot =
          await FirebaseDatabase.instance.ref('ArenaInfo/$arenaId').get();
      if (snapshot.value != null) {
        final arenaData = snapshot.value as Map<dynamic, dynamic>;
        arenaNames.add(arenaData['arena_name']);
        debugPrint("\n");
        debugPrint(arenaData['arena_name']);
      } else {
        arenaNames.add('Anonymous Arena'); //arena data is not available
      }
    }
    return arenaNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ArenaGo'),
          automaticallyImplyLeading: false, // This removes the back button
        ),
        body: Column
        (children: [
          ListView.builder(
            itemCount: _filteredFields.length,
            itemBuilder: (context, index) {
              final field = _filteredFields[index];
              return InkWell(
                onTap: () {
                  _changeScreen(field);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: ListTile(
                    tileColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 2.5,
                      ),
                    ),
                    leading: SizedBox(
                      width: 110,
                      height: 160,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                            image: NetworkImage(field['field_images'][0]),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    title: Text(_arenaNames[index]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Field ID: ${field['fieldId']}'),
                        const SizedBox(height: 0.5),
                        Text(
                            'Avg Price: Rs.${field['price'].toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: CircleAvatar(
                      radius: 22,
                      child: _buildFieldTypeEmojis(field['fieldType']),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              );
            },
          ),
        ]));
  }

  Widget _buildFieldTypeEmojis(String fieldType) {
    // Implement the logic to display emojis based on the field type
    return const Text('🏏 ⚽');
  }

  Future<void> _changeScreen(var field) async {
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
    FieldInfo fieldInfo = await _backend
        .fetchFieldInfo(field); // Implement this method to fetch FieldInfo

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => BookField(
                fieldData: fieldInfo,
              )),
    );
  }
}

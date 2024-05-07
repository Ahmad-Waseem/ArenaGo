import 'package:arenago/views/arenaPage.dart';
import 'package:arenago/views/owner_homepage.dart';
import 'package:arenago/views/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class BookField extends StatefulWidget {
  final FieldInfo fieldData;
  final List<String>? notifyFriendIds;

  BookField({Key? key, required this.fieldData, this.notifyFriendIds})
      : super(key: key);

  @override
  _BookFieldState createState() => _BookFieldState();
}

class _BookFieldState extends State<BookField> {
  List<TimeSlot> availableTimeSlots = [];
  TimeSlot? _selectedTimeSlot; // Declare a variable to store the selected time slot
  
  int price = 0;

  @override
  void initState() {
    super.initState();
    _filterAvailableTimeSlots();
    _calculatePrice();
  }

  void _filterAvailableTimeSlots() {
    final bookedTimeSlots = Set<TimeSlot>();

    // Retrieve booked time slots for the current field from the database
    final databaseRef = FirebaseDatabase.instance.ref().child('Bookings');
    databaseRef
        .orderByChild('fieldId')
        .equalTo(widget.fieldData.fieldId)
        .once()
        .then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      final dynamic data = snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values = data;
        values.forEach((key, value) {
          print('siuu ${key}, ${value}');
          // Check if the fieldId of the booking matches the fieldId of the current field
          if (value['fieldId'] == widget.fieldData.fieldId) {
            // Parse the booked time slot
            TimeSlot bookedSlot = TimeSlot(
              startTime: DateTime.parse(value['selectedTimeSlot']['startTime']),
              endTime: DateTime.parse(value['selectedTimeSlot']['endTime']),
            );
            print(bookedSlot.startTime);
            print(bookedSlot.endTime);

            // Check if the booked slot matches any of the field's time slots
            for (TimeSlot slot in widget.fieldData.timeSlots) {
              print(slot.startTime);
              print(slot.endTime);
              if (slot.startTime == bookedSlot.startTime &&
                  slot.endTime == bookedSlot.endTime) {
                bookedTimeSlots.add(bookedSlot);
                break; // Break out of the loop once a match is found
              }
            }
          }
        });
      }

      // Filter the available time slots based on the booked time slots
      setState(() {
        availableTimeSlots = widget.fieldData.timeSlots.where((slot) {
          TimeOfDay now = TimeOfDay.fromDateTime(DateTime.now());
          return !(bookedTimeSlots.contains(slot)) &&
              (now.hour < slot.endTime.hour ||
                  (now.hour == slot.endTime.hour &&
                      now.minute < slot.endTime.minute));
        }).toList();
      });
    }).catchError((error) {
      print('Error fetching bookings: $error');
    });
  }

  void _calculatePrice() {
    // Calculate the price based on the selected time slot and the field's pricing structure
    final now = DateTime.now();
    if (_selectedTimeSlot != null &&
        _selectedTimeSlot!.startTime.isBefore(now)) {
      // If the selected time slot has already started, use the base price
      price = widget.fieldData.basePrice;
    } else if (availableTimeSlots.length <
        widget.fieldData.timeSlots.length * 0.5) {
      // If more than half of the time slots are already booked, use the peak price
      price = widget.fieldData.peakPrice;
    } else {
      // Otherwise, use the normal price
      price = widget.fieldData.price;
    }
  }

  void _bookField() {
    // Store the booking information in the Bookings table in the real-time database
    final bookingId = FirebaseDatabase.instance.ref('Bookings').push().key;
    final bookingsRef = FirebaseDatabase.instance.ref('Bookings/$bookingId');
    bookingsRef.set({
      'bookingId': bookingId,
      'arenaId': widget.fieldData.arenaId,
      'fieldId': widget.fieldData.fieldId,
      'image': widget.fieldData.fieldImages?.first,
      'timestamp': DateTime.now().toString(),
      'price': price,
      'userId': FirebaseAuth
          .instance.currentUser!.uid, // Replace with the current user's ID
      'selectedTimeSlot': _selectedTimeSlot != null
          ? {
              'startTime': _selectedTimeSlot!.startTime.toString(),
              'endTime': _selectedTimeSlot!.endTime.toString(),
            }
          : null, // Store selected time slot or null if none is selected
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OwnerHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Field'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.0),
              _buildImageCarousel(widget.fieldData.fieldImages),
              SizedBox(height: 25.0),
              Center(
                child: Text(
                  'Field Info:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 18.0),
              Text(
                'Field Id: ${widget.fieldData.fieldId}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Field Type: ${widget.fieldData.fieldType}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Ground Type: ${widget.fieldData.groundType}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Dimensions: ${widget.fieldData.length} x ${widget.fieldData.width}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Available Material: ${widget.fieldData.availableMaterial}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 25.0),
              Center(
                child: Text(
                  'Available Time Slots:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 18.0),
              Center(
                child: _buildTimeSlotList(availableTimeSlots),
              ),
              SizedBox(height: 25.0),
              SizedBox(height: 25.0),
              Center(
                child: Text(
                  'Price: ₹$price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: _bookField,
                child: Text('Book Field'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<dynamic>? images) {
    if (images == null || images.isEmpty) {
      return SizedBox(height: 0); // No images, don't display carousel
    }
    return CarouselSlider(
      items: images
          .map((image) => Image.network(image, fit: BoxFit.cover))
          .toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 16 / 9,
        onPageChanged: (index, reason) => print('Page changed to $index'),
      ),
    );
  }

  Widget _buildTimeSlotList(List<TimeSlot> timeSlots) {
    if (timeSlots.isEmpty) {
      return const Text(
        'NO SLOTS AVAILABLE  (つ﹏⊂)',
        style: TextStyle(fontSize: 16, color: kPrimaryColor),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: timeSlots
          .map((slot) => RadioListTile<TimeSlot>(
                title: Text(
                  '${DateFormat('hh:mm').format(slot.startTime)} - ${DateFormat('hh:mm').format(slot.endTime)}',
                  style: const TextStyle(fontSize: 16),
                ),
                value: slot,
                groupValue: _selectedTimeSlot,
                onChanged: (value) {
                  setState(() {
                    _selectedTimeSlot = value;
                    _calculatePrice(); // Update price based on selected time slot
                  });
                },
              ))
          .toList(),
    );
  }
}

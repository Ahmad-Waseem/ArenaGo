// import 'package:arenago/views/arenaPage.dart'; // Assuming this imports ArenaInfo
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_database/firebase_database.dart'; // Add Firebase Database dependency

// class BookField extends StatefulWidget {
//   final FieldInfo fieldData;

//   const BookField({Key? key, required this.fieldData}) : super(key: key);

//   @override
//   State<BookField> createState() => _BookFieldState();
// }

// class _BookFieldState extends State<BookField> {
//   final _bookingTimeSlots = <DateTime>[]; // List to store selected time slots
//   final _database = FirebaseDatabase.instance; // Firebase Database instance

//   @override
//   Widget build(BuildContext context) {
//     final fieldData = widget.fieldData;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Book Field'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 15.0),
//               _buildImageCarousel(fieldData.fieldImages), // Image carousel
//               SizedBox(height: 25.0),
//               Text(
//                 'Field Info:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 18.0),
//               Text(
//                 'Field Id: ${fieldData.fieldId}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 'Field Type: ${fieldData.fieldType}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 'Ground Type: ${fieldData.groundType}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 'Dimensions: ${fieldData.length} x ${fieldData.width}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 'Available Material: ${fieldData.availableMaterial}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 8.0),
//               _buildPriceText(fieldData), // Function to determine and display price
//               SizedBox(height: 8.0),
//               _buildTimeSlots(fieldData.timeSlots), // Selectable time slots
//               SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: _bookField,
//                 child: Text('Book Field'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImageCarousel(List<dynamic>? images) {
//     if (images == null || images.isEmpty) {
//       return SizedBox(height: 0); // No images, don't display carousel
//     }
//     return CarouselSlider(
//       items: images
//           .map((image) => Image.network(image, fit: BoxFit.cover))
//           .toList(),
//       options: CarouselOptions(
//         // Enable autoplay
//         autoPlay: true,
//         // Use the built-in CarouselIndicator for pagination
//         enlargeCenterPage:
//             true, // Optional: Enlarge center page for a more prominent display
//         viewportFraction:
//             0.8, // Optional: Adjust the portion of the screen occupied by the carousel
//         aspectRatio: 16 / 9, // Optional: Set an aspect ratio for the carousel
//         onPageChanged: (index, reason) => print(
//             'Page changed to $index'), // Optional: Callback for page changes
//       ),
//     );
//   }
//   Widget _buildTimeSlots(List<TimeSlot>? timeSlots) {
//     if (timeSlots == null || timeSlots.isEmpty) {
//       return Text('No time slots available.', style: TextStyle(fontSize: 16));
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: timeSlots.map((slot) {
//         final isSelected = _bookingTimeSlots.contains(slot.startTime);
//         return CheckboxListTile(
//           title: Text(
//             '• ${DateFormat('hh:mm').format(slot.startTime)} - ${DateFormat('hh:mm').format(slot.endTime)}',
//             style: TextStyle(fontSize: 16),
//           ),
//           value: isSelected,
//           onChanged: (value) => setState(() => _bookingTimeSlots.contains(slot.startTime)
//               ? _bookingTimeSlots.remove(slot.startTime)
//               : _bookingTimeSlots.add(slot.startTime)),
//         );
//       }).toList(),
//     );
//   }

//   // Text _buildPriceText(FieldInfo fieldData) {
//   //   DateTime now = DateTime.now();
//   //   double price = fieldData.price.toDouble();

//   //   // Check for already booked slots (logic needs further implementation)
//   //   // 1. Query Bookings table for booked time slots for this field on the selected date (needs implementation)
//   //   // 2. Loop through selected time slots in _bookingTimeSlots
//   //   // 3. If any selected time slot conflicts with a booked slot, adjust price to peakPrice

//   //   // Here's a placeholder logic assuming you have a `checkBookedSlots` function:
//   //   final bookedSlots = checkBookedSlots(fieldData.fieldId, now); // Placeholder function - Replace with actual implementation
//   //   for (var slot in _bookingTimeSlots) {
//   //     if (bookedSlots.any((bookedSlot) => bookedSlot.contains(slot))) {
//   //       price = fieldData.peakPrice.toDouble();
//   //       break; // Exit loop after finding a conflict
//   //     }
//   //   }

//   //   // Check for already started time slots (assuming base price applies)
//   //   if (_bookingTimeSlots.any((slot) => slot.isBefore(now))) {
//   //     price = fieldData.basePrice.toDouble();
//   //   }

//   //   return Text(
//   //     'Price: ₹${price.toStringAsFixed(2)}', // Display price with two decimal places
//   //     style: TextStyle(fontSize: 16),
//   //   );
//   // }
// Text _buildPriceText(FieldInfo fieldData) {
//   DateTime now = DateTime.now();
//   double price = fieldData.price.toDouble();

//   // Check for already booked slots (logic needs further implementation)
//   final bookedSlots = checkBookedSlots(fieldData.fieldId, now); // Placeholder function - Replace with actual implementation

//   // Loop through selected time slots
//   for (var slot in _bookingTimeSlots) {
//     final isBooked = bookedSlots.any((bookedSlot) => bookedSlot.contains(slot));
//     if (isBooked) {
//       price = fieldData.peakPrice.toDouble();
//       break; // Exit loop after finding a conflict
//     }
//   }

//   // Check for already started time slots (assuming base price applies)
//   if (_bookingTimeSlots.any((slot) => slot.isBefore(now))) {
//     price = fieldData.basePrice.toDouble();
//   }

//   return Text(
//     'Price: ₹${price.toStringAsFixed(2)}', // Display price with two decimal places
//     style: TextStyle(fontSize: 16),
//   );
// }

//   Future<List<DateTime>> checkBookedSlots(String fieldId, DateTime date) async {
//     // Implement logic to query Bookings table using Firebase Database
//     // Here's a placeholder assuming you have a `bookingsRef` defined:
//     // final bookingsRef = FirebaseDatabase.instance.ref('Bookings');
//     // ... (query logic to retrieve booked slots for given fieldId and date)
//     // ... (return a list of DateTime objects representing booked time slots)

//     // Replace the placeholder with your actual implementation to fetch booked slots
//     return []; // Placeholder - Replace with actual booked slots
//   }

//   void _bookField() async {
//     if (_bookingTimeSlots.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please select at least one time slot to book.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Generate a unique booking ID (consider using a package like uuid)
//     final bookingId = DateTime.now().microsecondsSinceEpoch.toString();

//     // Prepare booking information
//     final image = widget.fieldData.fieldImages.isNotEmpty ? widget.fieldData.fieldImages[0] : ""; // Assuming first image for display
//     final price = _calculateTotalPrice(); // Function to calculate total price based on selected slots and field data
//     final userId = await _getCurrentUser(); // Function to get current user ID (replace with your implementation)

//     // Create a Booking object (consider creating a dedicated class)
//     final bookingData = {
//       'bookingId': bookingId,
//       'arenaId': "", // Assuming you have arena ID (replace with actual value)
//       'fieldId': widget.fieldData.fieldId,
//       'image': image,
//       'timestamp': DateTime.now().toIso8601String(),
//       'price': price,
//       'userId': userId,
//     };

//     // Write booking data to Firebase Database
//     final bookingsRef = _database.ref('Bookings/$bookingId');
//     await bookingsRef.set(bookingData);

//     // Show confirmation message or navigate to a confirmation page (optional)
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Field booked successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   double _calculateTotalPrice() {
//     // Implement logic to calculate total price based on selected time slots and field data
//     // Consider factors like price per time slot, duration of selected slots, etc.
//     // Placeholder - Replace with your actual price calculation logic
//     return 0.0; // Placeholder
//   }

//   Future<String> _getCurrentUser() async {
//     // Implement logic to retrieve current user ID from your authentication system
//     // Placeholder - Replace with your actual implementation to get current user ID
//     return ""; // Placeholder
//   }
// }
import 'package:arenago/views/arenaPage.dart';
import 'package:arenago/views/owner_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class BookField extends StatefulWidget {
  final FieldInfo fieldData;

  BookField({Key? key, required this.fieldData}) : super(key: key);

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

  // void _filterAvailableTimeSlots() {
  //   // Filter the available time slots based on the bookings in the database
  //   // and store them in the `availableTimeSlots` list
  //   availableTimeSlots = widget.fieldData.timeSlots.where((slot) {
  //     // Check if the time slot is available in the database
  //     // and add it to the `availableTimeSlots` list
  //     return true; // Implement the logic to check availability
  //   }).toList();
  // }
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
  if (_selectedTimeSlot != null && _selectedTimeSlot!.startTime.isBefore(now)) {
    // If the selected time slot has already started, use the base price
    price = widget.fieldData.basePrice;
  } else if (availableTimeSlots.length < widget.fieldData.timeSlots.length * 0.5) {
    // If more than half of the time slots are already booked, use the peak price
    price = widget.fieldData.peakPrice;
  } else {
    // Otherwise, use the normal price
    price = widget.fieldData.price;
  }
}


  // void _toggleTimeSlotSelection(TimeSlot timeSlot) {
  //   setState(() {
  //     if (selectedTimeSlots.contains(timeSlot)) {
  //       selectedTimeSlots.remove(timeSlot);
  //     } else {
  //       selectedTimeSlots.add(timeSlot);
  //     }
  //     _calculatePrice();
  //   });
  // }

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
    'userId': FirebaseAuth.instance.currentUser!.uid, // Replace with the current user's ID
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
              Text(
                'Field Info:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            Text(
                'Available Time Slots:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 18.0),
              _buildTimeSlotList(availableTimeSlots),
              SizedBox(height: 25.0),
              SizedBox(height: 25.0),
              Text(
                'Price: ₹$price',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: timeSlots.map((slot) => RadioListTile<TimeSlot>(
      title: Text(
        '${DateFormat('hh:mm').format(slot.startTime)} - ${DateFormat('hh:mm').format(slot.endTime)}',
        style: TextStyle(fontSize: 16),
      ),
      value: slot,
      groupValue: _selectedTimeSlot,
      onChanged: (value) {
        setState(() {
          _selectedTimeSlot = value;
          _calculatePrice(); // Update price based on selected time slot
        });
      },
    )).toList(),
  );
}

}
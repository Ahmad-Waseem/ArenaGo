import 'package:arenago/views/arenaPage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart'; // Replace with your actual import path

class FieldPage extends StatelessWidget {
  final FieldInfo fieldData;

  FieldPage({Key? key, required this.fieldData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Field Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.0),
              _buildImageCarousel(fieldData
                  .fieldImages), // Add image carousel if images provided
              SizedBox(height: 25.0),
              Text(
                'Field Info:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 18.0),
              Text(
                'Field Id: ${fieldData.fieldId}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Field Type: ${fieldData.fieldType}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Ground Type: ${fieldData.groundType}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Dimensions: ${fieldData.length} x ${fieldData.width}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Available Material: ${fieldData.availableMaterial}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Price: ₹${fieldData.price}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Base Price: ₹${fieldData.basePrice}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Peak Price: ₹${fieldData.peakPrice}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
             _buildTimeSlots(fieldData.timeSlots), // Add time slots list

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
        // Enable autoplay
        autoPlay: true,
        // Use the built-in CarouselIndicator for pagination
        enlargeCenterPage:
            true, // Optional: Enlarge center page for a more prominent display
        viewportFraction:
            0.8, // Optional: Adjust the portion of the screen occupied by the carousel
        aspectRatio: 16 / 9, // Optional: Set an aspect ratio for the carousel
        onPageChanged: (index, reason) => print(
            'Page changed to $index'), // Optional: Callback for page changes
      ),
    );
  }

Widget _buildTimeSlots(List<TimeSlot>? timeSlots) {
  if (timeSlots == null || timeSlots.isEmpty) {
    return Text('No time slots available.', style: TextStyle(fontSize: 16));
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: timeSlots.map((slot) => Text(
      '• ${DateFormat('hh:mm').format(slot.startTime)} - ${DateFormat('hh:mm').format(slot.endTime)}',
      style: TextStyle(fontSize: 16),
    )).toList(),
  );
}


}

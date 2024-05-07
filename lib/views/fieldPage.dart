import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:arenago/views/arenaPage.dart';

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
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              _buildImageCarousel(fieldData.fieldImages),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Field Info',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Field Id: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      fieldData.fieldId,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              _buildFieldInfoItem('Field Type', fieldData.fieldType),
              _buildFieldInfoItem('Ground Type', fieldData.groundType),
              _buildFieldInfoItem(
                  'Dimensions', '${fieldData.length} x ${fieldData.width}'),
              _buildFieldInfoItem(
                  'Available Material', fieldData.availableMaterial),
              _buildFieldInfoItem('Price', '₹${fieldData.price}'),
              _buildFieldInfoItem('Base Price', '₹${fieldData.basePrice}'),
              _buildFieldInfoItem('Peak Price', '₹${fieldData.peakPrice}'),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Time Slots',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10.0),
              _buildTimeSlots(fieldData.timeSlots),
              SizedBox(height: 50.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Implement your remove field logic here
                      },
                      child: Text('Remove Field'),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        // Implement your edit field logic here
                      },
                      child: Text('Edit Field'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<dynamic>? images) {
    if (images == null || images.isEmpty) {
      return Container(); // No images, don't display carousel
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
      ),
    );
  }

  Widget _buildFieldInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots(List<TimeSlot>? timeSlots) {
    if (timeSlots == null || timeSlots.isEmpty) {
      return Text(
        'No time slots available.',
        style: TextStyle(fontSize: 18, color: Colors.black54),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: timeSlots
            .map(
              (slot) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.blue,
                  ),
                  child: Text(
                    '${DateFormat('hh:mm').format(slot.startTime)} - ${DateFormat('hh:mm').format(slot.endTime)}',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

import 'package:arenago/views/add_fields.dart';
import 'package:arenago/views/fieldPage.dart';
import 'package:arenago/views/owner_homepage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArenaPage extends StatefulWidget {
  final ArenaInfo arena;

  const ArenaPage({Key? key, required this.arena}) : super(key: key);

  @override
  _ArenaPageState createState() => _ArenaPageState();
}

class _ArenaPageState extends State<ArenaPage> {
  List<FieldInfo> fields = [];

  @override
  void initState() {
    super.initState();
    _fetchFieldData();
  }

  void _fetchFieldData() {
    FirebaseDatabase.instance
        .ref()
        .child('FieldInfo')
        .orderByChild('arenaId')
        .equalTo(widget.arena.arenaId)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          fields = data.entries.map((entry) {
            final fieldData = entry.value as Map<dynamic, dynamic>;
            return FieldInfo(
              fieldId: entry.key,
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
          }).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arena Info'),
        backgroundColor: Color.fromARGB(255, 229, 224, 253),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildArenaInfo(widget.arena),
              SizedBox(height: 24.0),
              _buildFieldList(context, fields),
              SizedBox(height: 16.0),
            _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Navigate to edit arena page
          },
          child: Text('Edit Arena'),
        ),
        ElevatedButton(
          onPressed: () {
Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFieldView(arenaId: widget.arena.arenaId)),
    );          },
          child: Text('Add Field'),
        ),
      ],
    );
  }

  Widget _buildArenaInfo(ArenaInfo arenaData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        _buildImageCarousel(arenaData.arenaImages),
        SizedBox(height: 30.0),
        Text(
          arenaData.arenaName,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        _buildInfoItem('Arena ID', arenaData.arenaId),
        _buildInfoItem('Address',
            '${arenaData.address}, ${arenaData.town}, ${arenaData.city}'),
        _buildInfoItem('Contact', arenaData.contact),
        _buildInfoItem(
            'Hours', '${arenaData.startTime} - ${arenaData.endTime}'),
        SizedBox(height: 16.0),
        Center(
          child: Column(
            children: [
              Text(
                'Location:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: SizedBox(
                  height: 150, // Reduced the height of the map box
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(arenaData.location.latitude,
                          arenaData.location.longitude),
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('arena_location'),
                        position: LatLng(arenaData.location.latitude,
                            arenaData.location.longitude),
                      ),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    if (images.isEmpty) {
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
}

Widget _buildFieldList(BuildContext context, List<FieldInfo> fieldData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          'Fields',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: 16.0),
      for (final field in fieldData)
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FieldPage(fieldData: field),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Set border radius
              border: Border.all(
                color: const Color.fromARGB(255, 190, 190, 190), // Customize border color
                width: 1.0, // Customize border width
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 11.0,horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Field ID: ${field.fieldId}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Field Type: ${field.fieldType}'),
                Text('Price: \$${field.price}'),
                SizedBox(height: 8.0),
                // Add more field details as needed
              ],
            ),
          ),
        ),
    ],
  );
}

class FieldInfo {
  final String fieldId;
  final String arenaId;
  final String availableMaterial;
  final int basePrice;
  final String fieldType;
  final List<String> fieldImages;
  final String groundType;
  final int length;
  final int peakPrice;
  final int price;
  final List<TimeSlot> timeSlots;
  final int width;

  FieldInfo({
    required this.fieldId,
    required this.arenaId,
    required this.availableMaterial,
    required this.basePrice,
    required this.fieldType,
    required this.fieldImages,
    required this.groundType,
    required this.length,
    required this.peakPrice,
    required this.price,
    required this.timeSlots,
    required this.width,
  });
}

class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;

  TimeSlot({
    required this.startTime,
    required this.endTime,
  });
}

import 'package:arenago/views/fieldPage.dart';
import 'package:arenago/views/owner_homepage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/arenaPage.dart'; // Assuming DisplayPage location

class ArenaPage extends StatefulWidget {
    final ArenaInfo arena;

  const ArenaPage({Key? key, required this.arena}) : super(key: key);
  @override
  _ArenaPageState createState() => _ArenaPageState();
}

class _ArenaPageState extends State<ArenaPage> {

  Map<String, dynamic>? _arenaData; // Arena data from ArenaInfo
  List<Map<String, dynamic>>? _fields; // List of fields data from FieldData

  @override
  void initState() {
    super.initState();
    _fetchArenaData();
    _fetchFieldData(); // Fetch field data as well
  }

  void _fetchArenaData() async {
    // Implement your logic to fetch arena data from ArenaInfo (replace with your actual implementation)
    // ... (e.g., using Firebase Realtime Database)
    
    setState(() {
      //_arenaData = /* Your fetched arena data */;
    });
  }

  void _fetchFieldData() async {
    // Implement your logic to fetch field data from FieldData (replace with your actual implementation)
    // ... (e.g., using Firebase Realtime Database)
    
    setState(() {
      //_fields = /* Your fetched field data for this arena */; // Filter based on arena ID
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Arenas'),
      ),
      body: _arenaData == null || _fields == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildArenaInfo(_arenaData!), // Display arena information
                  SizedBox(height: 16.0),
                  _buildFieldList(_fields!), // Display list of fields
                ],
              ),
            ),
    );
  }

  Widget _buildArenaInfo(Map<String, dynamic> arenaData) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Arena Info:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          _buildImageCarousel(arenaData['arena_images']), // Add image carousel if images provided
          SizedBox(height: 8.0),
          Text('Arena ID: ${arenaData['arena_id']}'),
          SizedBox(height: 8.0),
          Text('Arena Name: ${arenaData['arena_name']}'),
          SizedBox(height: 8.0),
          Text('Address: ${arenaData['address']}'),
          SizedBox(height: 8.0),
          Text('Town: ${arenaData['town']}'),
          SizedBox(height: 8.0),
          Text('City: ${arenaData['city']}'),
          Text('Location: (Lat: ${arenaData['location']['latitude']}, Lon: ${arenaData['location']['longitude']})'),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<dynamic>? images) {
    if (images == null || images.isEmpty) {
      return SizedBox(height: 0); // No images, don't display carousel
    }
    return CarouselSlider(
      items: images.map((image) => Image.network(image, fit: BoxFit.cover)).toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true, // Optional: Enlarge center page for a more prominent display
        viewportFraction: 0.8, // Optional: Adjust the portion of the screen occupied by the carousel
        aspectRatio: 16/9, // Optional: Set an aspect ratio for the carousel items
        onPageChanged: (index, reason) => print('Page changed to $index'), // Optional: Callback for page changes
      ),
    );
  }

Widget _buildFieldList(List<Map<String, dynamic>> fields) {
  return ListView.builder(
    shrinkWrap: true, // Prevent list from expanding unnecessarily
    physics: NeverScrollableScrollPhysics(), // Disable scrolling for list view
    itemCount: fields.length,
    itemBuilder: (context, index) {
      final fieldData = fields[index];
      return ListTile(
        title: Text('Field ID: ${fieldData['fieldId']}'), // Display field ID
        onTap: () => _navigateToFieldPage(fieldData), // Navigate on tap
      );
    },
  );
}

void _navigateToFieldPage(Map<String, dynamic> fieldData) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FieldPage(fieldData: fieldData)),
  );
}
}
import 'dart:io';
import 'package:arenago/views/add_fields.dart';
import 'package:arenago/views/owner_homepage.dart';
import 'package:arenago/views/owner_profilescreen.dart';
import 'package:arenago/views/owner_search.dart';
import 'package:arenago/views/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart'; // For generating unique arena IDs

class AddArenaView extends StatefulWidget {
  @override
  _AddArenaViewState createState() => _AddArenaViewState();
}

class _AddArenaViewState extends State<AddArenaView> {
  final _formKey = GlobalKey<FormState>();
  final _arenaNameController = TextEditingController();
  final _arenaPriceController = TextEditingController();
  final _arenaAddressController = TextEditingController();
  final _arenaContactController = TextEditingController();
  final _arenaTownController = TextEditingController();
  final _arenaCityController = TextEditingController();

  final List<String> _selectedDays = [];

  TimeOfDay? _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay? _endTime = const TimeOfDay(hour: 20, minute: 0);
  List<File> _arenaImages = [];

  int _selectedIndex = 1;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    // There will be widgets in it
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Friends',
      style: optionStyle,
    ),
    Text(
      'Index 2: Search',
      style: optionStyle,
    ),
    Text(
      'Index 3: History',
      style: optionStyle,
    ),
    Text(
      'Index 4: Profile',
      style: optionStyle,
    ),
  ];


  //light color scheme
  final Color primaryColor = Colors.blue; // Replace kprimary color
  final Color darkColor = Colors.black; // Text color, dbg button


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
    });
    if (index == 4) {
      Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const OwnerProfileScreen(),
                    ));
    }
    else if (index == 2) {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const OwnerSearchPage(),
                    ));
    }
    else if (index == 1) {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => AddArenaView(),
                    ));
    }
    else if (index == 0) {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const OwnerHomePage(),
                    ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: dBackgroundColor,
      appBar: AppBar(
        title: const Text('Register Arena'),
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  controller: _arenaNameController,
                  textAlign: TextAlign.center, // Center the text horizontally
                  decoration: InputDecoration(
                    labelText: 'Arena Name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 2.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[200],
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter arena name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _arenaAddressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.add_location_alt_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _arenaTownController,
                      decoration: InputDecoration(
                        labelText: 'Town',
                        prefixIcon: Icon(Icons.add_home_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Town name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _arenaCityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter City name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _arenaContactController,
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Contact info';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _arenaPriceController,
                      decoration: InputDecoration(
                        labelText: 'Price (Rs. per hour)',
                        prefixIcon: Icon(Icons.price_change_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid price';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    const Text('Select Days: '),
                    const SizedBox(width: 8.0),
                    for (String day in [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun'
                    ])
                      FilterChip(
                        label: Text(
                          day,
                          style: TextStyle(
                            color: _selectedDays.contains(day)
                                ? Colors.white
                                : null,
                          ),
                        ),
                        selected: _selectedDays.contains(day),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedDays.add(day);
                            } else {
                              _selectedDays.remove(day);
                            }
                          });
                        },
                        selectedColor: kPrimaryColor,
                        backgroundColor: _selectedDays.contains(day)
                            ? kPrimaryColor // Change background color for selected chip
                            : null,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Set the border color
                    width: 1.0, // Set the border width
                  ),
                  borderRadius:
                      BorderRadius.circular(10.0), // Set border radius
                ),
                child: Row(
                  // Arrange start and end time boxes inline responsively
                  children: [
                    Flexible(
                      child: ListTile(
                        title: const Text('Opening Time'),
                        subtitle: Text(_startTime?.format(context) ?? ''),
                        onTap: () => _selectStartTime(context),
                      ),
                    ),
                    Container(
                      color: Colors.black, // Set the color of the divider
                      height: 50, // Set the height of the divider
                      width: 1, // Set the thickness of the divider
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      child: ListTile(
                        title: const Text('Closing Time'),
                        subtitle: Text(_endTime?.format(context) ?? ''),
                        onTap: () => _selectEndTime(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Arena Images: '),
                  IconButton(
                    icon: Icon(Icons.add_photo_alternate),
                    onPressed: _pickImages,
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Container(
                height: 100.0, // Set a fixed height for the ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _arenaImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Image.file(
                        _arenaImages[index],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                // Add this
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );
                    }
                    _addArena(); // Call the _addArena function
                  },
                  child: const Text(
                    'Add Arena',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration
                          .none, // Add underline for clickable effect
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:dBackgroundColor,
        unselectedItemColor: loginOutlinecolor,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stadium),
            label: 'Add Arena',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor, 
        onTap: _onItemTapped,
      ),

    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 8, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 20, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    setState(() {
      _arenaImages =
          pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    });
  }

  Future<void> _addArena() async {
    String arenaName = _arenaNameController.text.trim();
    String arenaPrice = _arenaPriceController.text.trim();

    // Perform validation as needed (refer to previous responses)

    //if (!FirebaseAuth.instance.currentUser!.isAuthenticated) {
    // Handle case where user is not logged in
    // ScaffoldMessenger.of(context).showSnackBar(
    // const SnackBar(content: Text('Please sign in to add an arena!')),
    //);
    //return;
    //}

    try {
      final arenaId = const Uuid().v4();
      // Create a reference to the arenas collection in Realtime Database
      final arenasRef = FirebaseDatabase.instance.ref('ArenaInfo/$arenaId');

      // Prepare arena data
      final arenaData = {
        'arena_id': arenaId,
        //'owner_id': FirebaseAuth.instance.currentUser!.uid,
        'arena_name': arenaName,
        'address': _arenaAddressController.text.trim(),
        'town': _arenaTownController.text.trim(),
        'city': _arenaCityController.text.trim(),
        'contact': _arenaContactController.text.trim(),
        'price':
            double.tryParse(arenaPrice) ?? 0.0, // Handle invalid price input
        'date':
            DateTime.now().toIso8601String(), // Use ISO 8601 timestamp format
        'start_time':
            _startTime?.format(context) ?? '', // Handle null start time
        'end_time': _endTime?.format(context) ?? '', // Handle null end time
        'arena_images': [], // Initialize empty arena_images list
      };

      // Add arena data to the database
      await arenasRef.set(arenaData);

      // Upload arena images to Firebase Storage (if any)
// Upload arena images to Firebase Storage (if any)
      if (_arenaImages.isNotEmpty) {
        final storageRef =
            FirebaseStorage.instance.ref().child('arena_images').child(arenaId);
        final imageUploadTasks = _arenaImages.map((image) =>
            storageRef.child(image.path.split('/').last).putFile(image));
        await Future.wait(imageUploadTasks);

        // Obtain download URLs for the uploaded images
        final List<String> imageDownloadUrls = [];
        for (final uploadTask in imageUploadTasks) {
          final imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
          imageDownloadUrls.add(imageUrl);
        }
        //After image uploads are complete, update arena_images with image URLs
        await arenasRef.update({
          'arena_images': imageDownloadUrls,
        });
      }

      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arena added successfully!')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddFieldView()));
    } on FirebaseException catch (error) {
      // Handle Firebase errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding arena: ${error.message}')),
      );
    } catch (error) {
      // Handle other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${error.toString()}')),
      );
    }
  }
   
}

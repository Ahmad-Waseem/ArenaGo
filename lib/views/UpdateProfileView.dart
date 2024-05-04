import 'dart:io';

import 'package:arenago/views/gmaps/EditableMap.dart';
import 'package:arenago/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:arenago/views/theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({Key? key}) : super(key: key);

  @override
  _UpdateProfileViewState createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressNumberController =
      TextEditingController();
  var _location;
  var _profilePic = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      String id = user!.uid;
      debugPrint('this user $id');

      final userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
      userRef.onValue.listen((event) async {
        var dataSnapshot = event.snapshot;
        var data = dataSnapshot.value as Map?;
        _usernameController.text = data?['username'] ?? '';
        _phoneNumberController.text = data?['phone'] ?? '';
        _addressNumberController.text = data?['address'] ?? '';
        _location = LatLng(
          data?['location']['latitude'] as double,
          data?['location']['longitude'] as double,
        );
        setState(() {
          _location = LatLng(
            data?['location']['latitude'] as double,
            data?['location']['longitude'] as double,
          );
          _profilePic = data!['profilePic'].toString();
        });
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _onSelectImageTap() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final pickedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          final storageReference =
              FirebaseStorage.instance.ref('profileImages/${pickedImage.name}');
          await storageReference.putFile(File(pickedImage.path));

          final imageUrl = await storageReference.getDownloadURL();

          // Realtime Database
          final userRef = FirebaseDatabase.instance.ref('users/$userId');
          //final profileRef = userRef.child('profilePic');
          userRef.update({
            'profilePic': imageUrl,
          });
        }
      } else {
        print('User ID is null or not authenticated.');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> updateUserData(
    String username,
    String phoneNumber,
    String address,
    LatLng location,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
        await userRef.update({
          'username': username,
          'phone': phoneNumber,
          'address': address,
          'location': {
            'latitude': location.latitude,
            'longitude': location.longitude,
          },
        });
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Edit Profile', style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Container(
                padding: const EdgeInsets.fromLTRB(100.0, 15.0, 100.0, 15.0),
                decoration: BoxDecoration(
                  color: loginOutlinecolor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: secondaryColor, width: 4),
                      ),
                      child: _profilePic.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(_profilePic),
                            )
                          : const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://w0.peakpx.com/wallpaper/43/184/HD-wallpaper-dream-twitter-search-twitter-dream-black.jpg'),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          color: Colors.black,
                          iconSize: 20,
                          onPressed: _onSelectImageTap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController, //for test purpose
                            decoration: InputDecoration(
                              labelText: 'User Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (value) {
                              if (value!.length < 11) {
                                return 'Phone number must be 11 digits long.';
                              }
                              return null; // Valid input
                            },
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _addressNumberController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.add_location_alt_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //////////
                    const SizedBox(height: 20),
                    const Text(
                      'Drag the pointer to select location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        height: 200,
                        child: _location == null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : EditableMap(
                                initialLocation: _location,
                                onLocationChanged: (newLocation) {
                                  setState(() {
                                    _location = newLocation;
                                  });
                                },
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final username = _usernameController.text;
                          final phoneNumber = _phoneNumberController.text;
                          final address = _addressNumberController.text;
                          final location = LatLng(0, 0);
                          await updateUserData(
                              _usernameController.text,
                              _phoneNumberController.text,
                              _addressNumberController.text,
                              _location ?? location);
                          // Implement any additional logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text('Save Changes',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Divider(),

                    // -- Created Date and Delete Button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.currentUser!.delete();
                            const SnackBar(
                              content:
                                  Text('Account Deleted: We will miss you :('),
                              backgroundColor: moderateErrorColor,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'requires-recent-login') {
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  content: Text(
                                      'SAFETY MEASURE!\nPlease Sign-Out and Log in Again.\nDeletion requires a recent Login in'),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          elevation: 0,
                          disabledBackgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text('Delete Account'),
                      ),
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
}

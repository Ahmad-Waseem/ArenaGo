import 'package:arenago/views/gmaps/EditableMap.dart';
import 'package:arenago/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:arenago/views/theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({Key? key}) : super(key: key);

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> 
{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressNumberController = TextEditingController();
  LatLng? _location;

  @override
  void initState()
  {
    super.initState();
    fetchUserData(_usernameController, _phoneNumberController, _addressNumberController, _location);
  }

Future<void> fetchUserData(
  TextEditingController usernameController,
  TextEditingController phoneNumberController,
  TextEditingController addressNumberController,
  LatLng? latlng,
) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        final userData = snapshot.value as Map<String, dynamic>;
        usernameController.text = userData['username'] as String;
        phoneNumberController.text = userData['phone'] as String;
        addressNumberController.text = userData['address'] as String;
        latlng = LatLng(
          userData['location']['latitude'] as double,
          userData['location']['longitude'] as double,
        );
      }
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Edit Profile', style: Theme.of(context).textTheme.headline4),
        //backgroundColor: loginOutlinecolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // -- IMAGE with ICON

              Container(
                padding: const EdgeInsets.fromLTRB(100.0, 15.0, 100.0, 15.0),
                //color: loginOutlinecolor,
                decoration: BoxDecoration(
                  color:
                      loginOutlinecolor, // Set the color to blue for the border
                  borderRadius: BorderRadius.circular(
                      40), // Set the border radius for rounded corners
                ),
                //width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: secondaryColor, width: 4),
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/logo.png'),
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
                        child: const Icon(Icons.camera_alt,
                            color: Colors.black, size: 20),
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
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'User Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    const BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneNumberController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    const BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // Allows only digits
                              LengthLimitingTextInputFormatter(11), // Maximum 11 characters
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
                                borderSide: BorderSide(color: loginOutlinecolor),
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
                                    const BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    const BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.visibility_off),
                                onPressed: () {},
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
                      borderRadius: BorderRadius.circular(
                          20.0), // Set the border radius for rounded corners
                      child: SizedBox(
                        height: 200,
                        child: EditableMap(
                                initialLocation: _location ?? const LatLng(31.582045, 74.329376), // Set initial location or default to (0, 0)
                                onLocationChanged: (newLocation) {
                                  _location = newLocation;
                                },
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text('Edit Profile',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 5),
                    
                    
                    
                    Divider(),
                    
                    // -- Created Date and Delete Button
                    Container(
                      width: double
                          .infinity, // Make the container extend from edge to edge horizontally
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          


                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginView()),
                            );
                            showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  content: Text('Signed Out Successfully!\nWill be waiting for you!'),
                              )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 244, 54, 86).withOpacity(0.1),
                          elevation: 0,
                          disabledBackgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text('Sign Out'),
                      ),
                    ),
                    // -- Created Date and Delete Button
                    Container(
                      width: double
                          .infinity, // Make the container extend from edge to edge horizontally
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.currentUser!.delete();

                            const SnackBar(
                                content: Text('Account Deleted: We will miss you! :('),
                                backgroundColor: moderateErrorColor
                              );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginView()),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'requires-recent-login') {
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  content: Text('SAFETY MEASURE!\nPlease Sign-Out and Log in Again.\nDeletion requires a recent Login in!'),
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

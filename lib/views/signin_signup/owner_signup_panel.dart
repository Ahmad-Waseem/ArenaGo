import 'package:arenago/views/Modules/userModules/UpdateProfileView.dart';



import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';





final FirebaseAuth auth = FirebaseAuth.instance;

class OwnerSignupPanel extends StatefulWidget {
  @override
  _OwnerSignupPanelState createState() => _OwnerSignupPanelState();
}

class _OwnerSignupPanelState extends State<OwnerSignupPanel> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _cnic = '';
  String _phone = '';

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double defaultLoginSize = size.height - (size.height * 0.2);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: defaultLoginSize,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Create Account',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: kBackgroundColor),
              ),
              const SizedBox(height: 15),
              Image.asset('assets/logo.png', width: 200, height: 200),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: kBackgroundColor),
                  hintText: 'Username',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: kBackgroundColor),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail, color: kBackgroundColor),
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: kBackgroundColor),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: kBackgroundColor),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }

                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key, color: kBackgroundColor),
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: kBackgroundColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _password) {
                    return 'Passwords do not match!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _confirmPassword = value!;
                },
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key, color: kBackgroundColor),
                  hintText: 'Confirm Password',
                  hintStyle: const TextStyle(color: kBackgroundColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone, color: kBackgroundColor),
                      hintText: 'Phone No.',
                      hintStyle: const TextStyle(color: kBackgroundColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),
                TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your CNIC number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cnic = value!;
                },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.badge, color: kBackgroundColor),
                      hintText: 'CNIC No.',
                      hintStyle: const TextStyle(color: kBackgroundColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  
                const SizedBox(height: 15),






              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    
                    try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
                      print('Owner created: ${credential.user!.uid}');
                      addUserToRealtimeDatabase(_username, _cnic, _phone);                  //update _username
                      // Display success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Owner account created successfully')),
                      );
                      // Clear form fields
                      _formKey.currentState!.reset();
                      // Navigate to the next screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => UpdateProfileView()),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        // Display error message for weak password
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('The password provided is too weak')),
                        );
                      } else if (e.code == 'email-already-in-use') {
                        // Display error message for existing email
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('The email address is already in use by another account')),
                        );
                      }
                    } catch (e) {
                      print(e);
                      // Display generic error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('An error occurred while creating the user account')),
                      );
                    }
                  }
                  
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  foregroundColor: loginOutlinecolor,
                ),
                child: const Text('REGISTER'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> addUserToRealtimeDatabase(String username, String cnic, String phone) async {
  try {
    final user = auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      //final defaultPosition = LatLng(31.582045, 74.329376);
      final userRef = FirebaseDatabase.instance.ref('owners/$uid');

      // Set user data (create or update)
      await userRef.set({
        'uid': uid,
        'username': username,
        'cnic':cnic,
        'phone':phone,
        // 'location': {
        //   'latitude': defaultPosition.latitude,
        //   'longitude': defaultPosition.longitude,
        // },
      });

      print('User data added to Realtime Database successfully!');
    } else {
      print('Error: auth.currentUser is null');
    }
  } catch (e) {
    print('Error adding user data to Realtime Database: $e');
  }
}
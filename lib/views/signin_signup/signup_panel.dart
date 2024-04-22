import 'package:arenago/views/add_arena.dart';
import 'package:arenago/views/homepage.dart';
import 'package:arenago/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



final FirebaseAuth auth = FirebaseAuth.instance;

class SignupPanel extends StatefulWidget {
  @override
  _SignupPanelState createState() => _SignupPanelState();
}

class _SignupPanelState extends State<SignupPanel> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

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
                    return 'Passwords do not match';
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
<<<<<<< Updated upstream
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
=======
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
                      print('User created: ${credential.user!.uid}');
                      addUserToFirestore(_username);                  //update _username
                      // Display success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User account created successfully')),
                      );
                      // Clear form fields
                      _formKey.currentState!.reset();
                      // Navigate to the next screen
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddArenaView()),
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
>>>>>>> Stashed changes
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



// Function to add user data to Firestore
Future<void> addUserToFirestore(String username) async {
  try {
    String uid = auth.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    // Set user data (create or update)
    await userRef.set({
      'uid': uid,
      'username': username,
    }, );  // Use merge: true to avoid overwriting existing data

    print('User data added to Firestore successfully!');
  } catch (e) {
    print('Error adding user data to Firestore: $e');
  }
}





  // @override
  // Widget build(BuildContext context) {
  //   // Existing code remains the same

  //   ElevatedButton(
  //     onPressed: () async {
  //       if (_formKey.currentState!.validate()) {
  //         _formKey.currentState!.save();
  //         try {
  //           // Create user account
  //           final credential = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
  //           print('User created: ${credential.user!.uid}');

  //           // Update user profile with username
  //           await credential.user!.updateDisplayName(_username);

  //           // Store username in Firestore
  //           await _firestore.collection('users').doc(credential.user!.uid).set({
  //             'username': _username,
  //             'email': _email,
  //           });

  //           // Display success message
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('User account created successfully')),
  //           );

  //           // Clear form fields
  //           _formKey.currentState!.reset();

  //           // Navigate to the next screen
  //           Navigator.of(context).push(
  //             MaterialPageRoute(builder: (context) => AddArenaView()),
  //           );
  //         } catch (e) {
  //           print(e);
  //           // Display generic error message
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('An error occurred while creating the user account')),
  //           );
  //         }
  //       }
  //     },
  //     // Existing code remains the same
  //   );
  // }





// import 'package:arenago/views/add_arena.dart';
// import 'package:flutter/material.dart';
// import 'package:arenago/views/theme.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SignupPanel extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//     final Size size = MediaQuery.of(context).size;
//     final double defaultLoginSize = size.height - (size.height * 0.2);
    
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       height: defaultLoginSize,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 8),
//             const Text(
//               'Create Account',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: kBackgroundColor),
//             ),
//             const SizedBox(height: 15),
//             Image.asset('assets/logo.png', width: 200, height: 200),
//             const SizedBox(height: 15),
//             TextField(
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.person, color: kBackgroundColor),
//                 hintText: 'Username',
//                 hintStyle: const TextStyle(color: Colors.white),
//                 border: OutlineInputBorder(
//                   borderSide: const BorderSide(color: kBackgroundColor),
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.mail, color: kBackgroundColor),
//                 hintText: 'Email',
//                 hintStyle: const TextStyle(color: kBackgroundColor),
//                 border: OutlineInputBorder(
//                   borderSide: const BorderSide(color: kBackgroundColor),
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.key, color: kBackgroundColor),
//                 hintText: 'Password',
//                 hintStyle: const TextStyle(color: kBackgroundColor),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.key, color: kBackgroundColor),
//                 hintText: 'Confirm Password',
//                 hintStyle: const TextStyle(color: kBackgroundColor),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => AddArenaView(),
//                 ));
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 foregroundColor: loginOutlinecolor,
//               ),
//               child: const Text('REGISTER'),
//             ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:arenago/views/Modules/ownerModules/owner_login_view.dart';
import 'package:arenago/views/theme.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/auxilaryPages/homepage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:arenago/views/login_helpers/forgot_pw.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  });

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double defaultLoginSize = size.height - (size.height * 0.2);

    return AnimatedOpacity(
      opacity: widget.isLogin ? 1.0 : 0.0,
      duration: widget.animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: size.width,
          height: defaultLoginSize,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'User Account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  const SizedBox(height: 40),
                  Image.asset('assets/logo.png', width: 200, height: 200),
                  const SizedBox(height: 40),
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
                      prefixIcon: const Icon(Icons.mail),
                      hintText: 'Username or Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
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
                      prefixIcon: const Icon(Icons.key),
                      hintText: 'Password',
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
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          // Handle the "Forgot Password" text click here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()));
                        },
                        child: const Text(
                          'Forgot Password',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: secondaryColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Handle the "Business Account" text click here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OwnerLoginView()));
                        },
                        child: const Text(
                          'Business Account?',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: secondaryColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          final credentials = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: _email,
                            password: _password,
                          );
                          if (credentials.user != null) {
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login Sucessful'),
                                backgroundColor: loginButtoncolor
                              ));
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No user found for that email.'),
                                backgroundColor: moderateErrorColor
                              ),
                            );
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Wrong password provided for that user.'
                                    ),
                                backgroundColor: moderateErrorColor

                              ),
                            );
                          }else if (e.code == 'too-many-requests') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Too Many Attempts: Attempt after few minutes'
                                    ),
                                backgroundColor: moderateErrorColor

                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Error. Make sure Email/password are correct'),
                                    backgroundColor: moderateErrorColor
                              ),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}










// import 'package:arenago/views/ProfileScreen.dart';
// import 'package:arenago/views/add_fields.dart';
// import 'package:arenago/views/owner_login_view.dart';
// import 'package:arenago/views/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:arenago/views/homepage.dart';
// import 'package:arenago/views/add_arena.dart';



// class LoginForm extends StatelessWidget {
//   const LoginForm({
//     super.key,
//     required this.isLogin,
//     required this.animationDuration,
//     required this.size,
//     required this.defaultLoginSize,
//   });

//   final bool isLogin;
//   final Duration animationDuration;
//   final Size size;
//   final double defaultLoginSize;

//   @override 
//   Widget build(BuildContext context) {
      
//     return AnimatedOpacity(
//       opacity: isLogin ? 1.0 : 0.0,
//       duration: animationDuration * 4,
//       child: Align(
//         alignment: Alignment.center,
//         child: SizedBox(
//           width: size.width,
//           height: defaultLoginSize,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
              
//               children: [
//                 // Add field button as login view (will fade away when animation called)
//                 //   const Text(
//                 //   'Add field!',
//                 //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//                 // ),
//                 const Text(
//                   'User Account',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
//                 ),
//                 const SizedBox(height: 40),
//                 Image.asset('assets/logo.png', 
//                 width: 200,
//                 height: 200,), // Use a PNG image
//                 const SizedBox(height: 40),
//                 TextField(
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.mail),
//                     hintText: 'Username or Email',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.key),
//                     hintText: 'Password',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     //text is not clickabl, use Inkwell instead
//                     InkWell(
//                       onTap: () {
//                         // Handle the "Forgot Password" text click here
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFieldView()));
//                       },
//                       child: const Text(
//                         'Forgot Password',
//                         textAlign: TextAlign.right,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                           color: secondaryColor,
//                           decoration: TextDecoration.none,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         // Handle the "Business Account" text click here
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerLoginView()));
//                       },
//                       child: const Text(
//                         'Business Account?',
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                           color: secondaryColor,
//                           decoration: TextDecoration.none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),


//             const SizedBox(height: 15),
//                 ElevatedButton(
//                   onPressed: () 
//                   {
//                     Navigator.of(context).push(MaterialPageRoute
//                     (
//                       builder: (context) => const HomePage(),
//                     ));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ), // Add your login logic here
//                   child: const Text('LOGIN',
//                   style: TextStyle(
//                     color:secondaryColor,
//                   ),
//                 ),
//                 ),
//                 const SizedBox(height: 15),

                
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// }

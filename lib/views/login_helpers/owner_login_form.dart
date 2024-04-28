import 'package:arenago/views/add_fields.dart';
import 'package:arenago/views/login_view.dart';
import 'package:arenago/views/owner_homepage.dart';
import 'package:arenago/views/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/homepage.dart';
import 'package:arenago/views/login_helpers/owner_forgot_pw.dart';

class LoginForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLogin ? 1.0 : 0.0,
      duration: animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: size.width,
          height: defaultLoginSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add field button as login view (will fade away when animation called)
                //   const Text(
                //   'Add field!',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                // ),
                const Text(
                  'Business Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                const SizedBox(height: 40),
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                ), // Use a PNG image
                const SizedBox(height: 40),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail),
                    hintText: 'Username or Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.key),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //text is not clickabl, use Inkwell instead
                    InkWell(
                      onTap: () {
                        // Handle the "Forgot Password" text click here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const OwnerForgotPasswordPage()));
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
                                builder: (context) => const LoginView()));
                      },
                      child: const Text(
                        'User Account?',
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

                // TextButton(
                //     onPressed:  () {  navigateToHomePage(context);},

                //  child: Text(
                //   'Business Account?',

                //   textAlign: TextAlign.right,
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 13,
                //     color:secondaryColor,
                //     decoration: TextDecoration.none, // Add underline for clickable effect
                //   ),
                // ),),

                // void navigateToHomePage(BuildContext context) {
                // Navigator.of(context).push(MaterialPageRoute(
                // builder: (context) => const HomePage(),
                // ));
                // }

                // Inside your build method or widget tree
                // TextButton(
                //     onPressed: navigateToHomePage,

                //   child: Text(
                //             'Business Account?',

                //             textAlign: TextAlign.right,
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 13,
                //               color:secondaryColor,
                //               decoration: TextDecoration.none, // Add underline for clickable effect
                //             ),
                //           ),
                // ),

                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OwnerHomePage(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ), // Add your login logic here
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

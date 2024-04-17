import 'package:arenago/views/theme.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/homepage.dart';

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
                  'Welcome!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 40),
                Image.asset('assets/logo.png', 
                width: 200,
                height: 200,), // Use a PNG image
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () 
                  {
                    Navigator.of(context).push(MaterialPageRoute
                    (
                      builder: (context) => const HomePage(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ), // Add your login logic here
                  child: const Text('LOGIN'),
                ),
                const SizedBox(height: 15),

          const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
            'Add field',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color:loginOutlinecolor, // Change the color as desired
              decoration: TextDecoration.none, // Add underline for clickable effect
            ),
          ),

           Text('    ||    '),

           Text(
            'Sign in field',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color:loginOutlinecolor, // Change the color as desired
              decoration: TextDecoration.none, // Add underline for clickable effect
            ),
          ),
          ],
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

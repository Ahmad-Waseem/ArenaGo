import 'package:arenago/views/add_arena.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';

class SignupPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final double defaultLoginSize = size.height - (size.height * 0.2);
    
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: defaultLoginSize,
      child: SingleChildScrollView(
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
            TextField(
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
            TextField(
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
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.key, color: kBackgroundColor),
                hintText: 'Password',
                hintStyle: const TextStyle(color: kBackgroundColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.key, color: kBackgroundColor),
                hintText: 'Confirm Password',
                hintStyle: const TextStyle(color: kBackgroundColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddArenaView(),
                ));
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
    );
  }
}

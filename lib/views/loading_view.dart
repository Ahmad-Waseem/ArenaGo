import 'dart:async';
import 'package:arenago/views/login_view.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with SingleTickerProviderStateMixin {
  late double _opacity;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _opacity = 0.0;

    // Start fading in the ArenaGo text
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Start rotating animation for loading circles
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    // Add a delay of 2 seconds before navigating to the login page
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 0, 64), // Set background color to orange
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fade in ArenaGo text
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Text(
                'ArenaGo',
                style: TextStyle(
                  fontSize: 44,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16), // Add some space between ArenaGo and loading animation
            // Loading animation with circles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: ScaleTransition(
                    scale: _animationController.drive(
                      Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

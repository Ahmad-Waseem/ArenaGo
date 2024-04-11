// The scrollabledragable MENU for Profile Button in Bottom Navbar:
//Doc link: https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
//IT IS NOT BOTTOM SHEET

import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';

class ProfileMenu extends StatelessWidget {
  final Function onToggle; // Callback function to handle menu visibility toggling

  const ProfileMenu({Key? key, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView( 
        child: Container(
          
          child: Column( // Replace ListView
            children: [
              ListTile(
                title: Text('My Account'),
                textColor: loginOutlinecolor,
                onTap: () => Navigator.pop(context), // Example action on tap
              ),
              ListTile(
                title: Text('Settings'),
                textColor: loginOutlinecolor,
                onTap: () => Navigator.pop(context), // Example action on tap
              ),
              ListTile(
                title: Text('Info'),
                textColor: loginOutlinecolor,
                onTap: () => Navigator.pop(context), // Example action on tap
              ),
            ],
          ),
        ),
      ),
    );
  }
}

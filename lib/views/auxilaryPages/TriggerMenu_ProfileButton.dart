// // The scrollabledragable MENU for Profile Button in Bottom Navbar:
// //Doc link: https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
// //IT IS NOT BOTTOM SHEET

// import 'package:arenago/views/ProfileScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:arenago/views/theme.dart';
// import 'package:arenago/views/example.dart';

// class ProfileMenu extends StatelessWidget {
//   final Function onToggle; // Callback function to handle menu visibility toggling

//   const ProfileMenu({super.key, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       body: SingleChildScrollView( 
//         child: Container(
          
//           child: Column( // Replace ListView
//             children: [
//               ListTile(
//                 title: const Text('My Account'),
//                 textColor: loginOutlinecolor,
//                 onTap: () {
//                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));//const ProfileScreen()),);
//                 }, // Example action on tap
//               ),
//               ListTile(
//                 title: const Text('Settings'),
//                 textColor: loginOutlinecolor,
//                 onTap: () => Navigator.pop(context), // Example action on tap
//               ),
//               ListTile(
//                 title: const Text('Info'),
//                 textColor: loginOutlinecolor,
//                 onTap: () => Navigator.pop(context), // Example action on tap
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

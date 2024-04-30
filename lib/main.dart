import 'package:arenago/views/UpdateProfileView.dart';
import 'package:arenago/views/add_arena.dart';
import 'package:arenago/views/add_fields.dart';
import 'package:arenago/views/homepage.dart';
import 'package:arenago/views/login_view.dart';
import 'package:arenago/views/owner_login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  User? user;

  @override
  void initState(){
    super.initState();
    user = FirebaseAuth.instance.currentUser;

  }
  
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      theme: ThemeData(
        primaryColor: loginOutlinecolor,
      ),
      home: user != null ? const HomePage() : const LoginView(),

      //routes: {
      //'/registration/': (context) => const RegistrationView(),
      //'/login/': (context) => const LoginView(),
      //'/home': (context) => const HomePage()
      //},
      //initialRoute: '/home',
    );
  }
}

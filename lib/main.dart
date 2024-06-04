


import 'package:arenago/views/auxilaryPages/homepage.dart';
import 'package:arenago/views/signin_signup/login_view.dart';
import 'package:arenago/views/Modules/ownerModules/owner_homepage.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'firebase_options.dart';


//import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
      //home: OwnerHomePage()
      //routes: {
      //'/registration/': (context) => const RegistrationView(),
      //'/login/': (context) => const LoginView(),
      //'/home': (context) => const HomePage()
      //},
      //initialRoute: '/home',
    );
  }
}

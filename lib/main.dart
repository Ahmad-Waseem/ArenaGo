import 'package:arenago/views/add_arena.dart';
import 'package:arenago/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
//import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      theme: ThemeData(
        primaryColor: loginOutlinecolor,
      ),
      home: const LoginView(),

      //routes: {
        //'/registration/': (context) => const RegistrationView(),
        //'/login/': (context) => const LoginView(),
        //'/home': (context) => const HomePage()
  //},
  //initialRoute: '/home',
    );
  }
}

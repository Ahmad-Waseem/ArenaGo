import 'package:arenago/views/loading_view.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return const MaterialApp(
      home: LoadingView(),

      //routes: {
        //'/registration/': (context) => const RegistrationView(),
        //'/login/': (context) => const LoginView(),
        //'/home': (context) => const HomePage()
  //},
  //initialRoute: '/home',
    );
  }
}

import 'package:flutter/material.dart';

Color buttonColor = const Color.fromRGBO(48, 83, 62, 1);
const double space_in_between = 10;
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(48, 83, 62, 1), // Set primary color
        hintColor: const Color.fromRGBO(48, 83, 62, 1), // Set accent color
        // Add more theme properties as needed
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: const Stack
        (
          children: [AnimatedPositionedLogo(),LoginFormField(),],
        )
      ),
    );
  }
}

class AnimatedPositionedLogo extends StatefulWidget {
  const AnimatedPositionedLogo({super.key});

  @override
  State<AnimatedPositionedLogo> createState() => _AnimatedPositionedLogoState();
}

class _AnimatedPositionedLogoState extends State<AnimatedPositionedLogo> 
{
  bool selected = false;

  @override
  void initState() 
  {
    super.initState();
    // Start the animation when the widget is initialized
    Future.delayed(const Duration(milliseconds: 500), () 
    {
      setState(() {
        selected = !selected;
      });
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return Stack(
      children: <Widget>
      [
        AnimatedPositioned
        (
          top: selected ? 0.0 : 50.0, //adjust the top value here
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: Image.asset('assets/logo.png', width: 250, height: 250,), // Only one child here
        ),
      ],
    );
  }
}


class LoginFormField extends StatelessWidget
{
  const LoginFormField({super.key});

  @override
  Widget build(BuildContext context)
  {
    final screenWidth = MediaQuery.of(context).size.width;
    final HorizontalpaddingSize = screenWidth * 0.07; // 70% of screen width
    final VerticalpaddingSize = screenWidth * 0.01; // 20% of screen width

    return Center
    (
    child: Column(
      mainAxisSize: MainAxisSize.min, // Prevent column from expanding
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: HorizontalpaddingSize),
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(
                color:  Color.fromRGBO(0, 151, 178, 1), // Custom outline color
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(
                color:  Color.fromRGBO(0, 151, 178, 1), // Custom outline color
                ),
              ),
              labelText: 'User Name',
              hintText: 'Enter valid Gmail or Phone Number',
            ),
          ),
        ),
        const SizedBox(height: space_in_between), // Spacing between fields (optional)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: HorizontalpaddingSize),
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(
                color:  Color.fromRGBO(0, 151, 178, 1), // Custom outline color
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(
                color:  Color.fromRGBO(0, 151, 178, 1), // Custom outline color
                ),
              ),
              labelText: 'Password',
              hintText: 'Enter your Password',
              //fillColor: Color.fromRGBO(0, 151, 178, 1)
            ),
          ),
        ),
        const SizedBox(height: space_in_between), // Spacing between fields
        FractionallySizedBox(
          widthFactor: 0.8, // 60% of available width
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color.fromRGBO(48, 83, 62, 1)),
            onPressed: () {},
            child: const Text('Login'),
          ),
        ),
      ],
    ),
  );

  }
}



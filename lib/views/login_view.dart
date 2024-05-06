

import 'package:arenago/views/signin_signup/signup_panel.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/login_helpers/login_form.dart';
import 'package:arenago/views/login_helpers/cancel_button.dart';





class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  
  bool isLogin = true;
  late Animation<double> containerSize;
  AnimationController? animationController;
  Duration animationDuration = const Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context).viewInsets.bottom; // we are using this to determine Keyboard is opened or not
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize = Tween<double>(begin: size.height * 0.1, end: defaultRegisterSize).animate(CurvedAnimation(parent: animationController!, curve: Curves.linear));

    return Scaffold(
      body: Stack(
        children: [
          // Add field button on top
        //   Positioned(
        //   top: 40, // Adjust the value to position it vertically
        //   width: size.width,
        //   child: const Center(
        //     child: Text(
        //       'Add Field',
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 20,
        //       ),
        //     ),
        //   ),
        // ),

    //The added circular decors
          Positioned(
            top: 100,
            right: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: loginOutlinecolor
              ),
            )
          ),

          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: loginOutlinecolor
              ),
            )
          ),

          // Cancel Button
          CancelButton(
            isLogin: isLogin,
            animationDuration: animationDuration,
            size: size,
            animationController: animationController,
            tapEvent: isLogin ? null : () { // returning null to disable the button
              animationController!.reverse();
              setState(() {
                isLogin = !isLogin;
              });
            },
          ),

          // Login Form
          LoginForm(isLogin: isLogin, animationDuration: animationDuration, size: size, defaultLoginSize: defaultLoginSize),

          // Register Container
          AnimatedBuilder(
            animation: animationController!,
            builder: (context, child) {
              if (viewInset == 0 && isLogin) {
                return buildRegisterContainer();
              } else if (!isLogin) {
                return buildRegisterContainer();
              }

              // Returning empty container to hide the widget
              return Container();
            },
          ),

          Visibility(
            visible: !isLogin,
            child: Align(
                    alignment: Alignment.center,
                    child: SignupPanel(),          
        ),
      ),
          // Register Form
          //RegisterForm(isLogin: isLogin, animationDuration: animationDuration, size: size, defaultLoginSize: defaultRegisterSize),
        ],
        
      ),
    );
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
          color: loginOutlinecolor
        ),

        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin ? null : () {
            animationController!.forward();
            setState(() {
              isLogin = !isLogin;
            });
          },
          child: isLogin ? const Text(
            "Don't have an account? Sign up",
            style: TextStyle(
              color: kBackgroundColor ,
              fontSize: 18
            ),
          ) : null,
        ),
      ),
    );
  }

  
}




// class _LoginViewState extends State<LoginView> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: const Color.fromRGBO(48, 83, 62, 1), // Set primary color
//         hintColor: const Color.fromRGBO(48, 83, 62, 1), // Set accent color
//         // Add more theme properties as needed
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Login"),
//         ),
//         body: const Stack
//         (
//           children: [AnimatedPositionedLogo(),LoginFormField(),],
//         )
//       ),
//     );
//   }
// }

// class AnimatedPositionedLogo extends StatefulWidget {
//   const AnimatedPositionedLogo({super.key});

//   @override
//   State<AnimatedPositionedLogo> createState() => _AnimatedPositionedLogoState();
// }

// class _AnimatedPositionedLogoState extends State<AnimatedPositionedLogo> 
// {
//   bool selected = false;

//   @override
//   void initState() 
//   {
//     super.initState();
//     // Start the animation when the widget is initialized
//     Future.delayed(const Duration(milliseconds: 500), () 
//     {
//       setState(() {
//         selected = !selected;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) 
//   {
//     return Stack(
//       children: <Widget>
//       [
//         AnimatedPositioned
//         (
//           top: selected ? 0.0 : 50.0, //adjust the top value here
//           duration: const Duration(seconds: 2),
//           curve: Curves.fastOutSlowIn,
//           child: Image.asset('assets/logo.png', width: 250, height: 250,), // Only one child here
//         ),
//       ],
//     );
//   }
// }









// class LoginFormField extends StatelessWidget
// {
//   const LoginFormField({super.key});

//   @override
//   Widget build(BuildContext context)
//   {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final HorizontalpaddingSize = screenWidth * 0.07; // 70% of screen width
//     final VerticalpaddingSize = screenWidth * 0.01; // 20% of screen width

//     return Center
//     (
//     child: Column(
//       mainAxisSize: MainAxisSize.min, // Prevent column from expanding
//       mainAxisAlignment: MainAxisAlignment.center, // Center vertically
//       crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: HorizontalpaddingSize),
//           child: TextFormField(
//             decoration: InputDecoration(
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(40.0),
//                 borderSide: const BorderSide(
//                 color:  Color.fromRGBO(0, 151, 178, 1), // Custom outline color
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(40.0),
//                 borderSide: const BorderSide(
//                 color:  Color.fromRGBO(0, 151, 178, 1), // Custom outline color
//                 ),
//               ),
//               labelText: 'User Name',
//               hintText: 'Enter valid Gmail or Phone Number',
//             ),
//           ),
//         ),
//         const SizedBox(height: space_in_between), // Spacing between fields (optional)
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: HorizontalpaddingSize),
//           child: TextFormField(
//             obscureText: true,
//             decoration: InputDecoration(
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(40.0),
//                 borderSide: const BorderSide(
//                 color:  Color.fromRGBO(0, 151, 178, 1), // Custom outline color
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(40.0),
//                 borderSide: const BorderSide(
//                 color:  Color.fromRGBO(0, 151, 178, 1), // Custom outline color
//                 ),
//               ),
//               labelText: 'Password',
//               hintText: 'Enter your Password',
//               //fillColor: Color.fromRGBO(0, 151, 178, 1)
//             ),
//           ),
//         ),
//         const SizedBox(height: space_in_between), // Spacing between fields
//         FractionallySizedBox(
//           widthFactor: 0.8, // 60% of available width
//           child: FilledButton(
//             style: FilledButton.styleFrom(backgroundColor: const Color.fromRGBO(48, 83, 62, 1)),
//             onPressed: () {},
//             child: const Text('Login'),
//           ),
//         ),
//       ],
//     ),
//   );

//   }
// }



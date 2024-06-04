// import 'dart:convert';
// import 'package:flutter/material.dart';
// //import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';

// class CheckoutScreen extends StatefulWidget {
//   final int price; // Price user has to pay (in cents)

//   const CheckoutScreen({Key? key, required this.price}) : super(key: key);

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//     dynamic createPaymentIntent(String amount, String currency) async {
//     try {
//         final body= {
//           'amount': amount,
//           'currency': currency,
//         };
//       final response = await http.post(
//         Uri.parse('https://10.0.2.2:5050/api/payment'),
//         body:body,
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'}
       
//       );
//       print(body);
// return jsonDecode(response.body);

//     } catch (err) {
//       if(kDebugMode)
//         print("siu error ${err}");
//     }
//   }
//    Future<void> makePayment(BuildContext context) async {
//     try {
//       // Calculate Stripe-compatible amount (in cents)
//       final amount = widget.price * 100; // Assuming price is in cents
//       final paymentIntentData = await createPaymentIntent('100', 'usd'); // Replace with your currency

//     await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
//       paymentIntentClientSecret: paymentIntentData['client_secret'],
//       style: ThemeMode.light,
//       customFlow: false,
//       merchantDisplayName: 'Zaid Asif'
//     ))
//     .then((value) {
//       displayPaymentSheet(context);
//     });

//     } catch (error) {
//       if(kDebugMode){
//         print(error);
//       }
//     }
//    }
//    void displayPaymentSheet(BuildContext context) async {
//     try{
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Paid Successfully!")));
//       });
//     } on StripeException catch (e){
//       if(kDebugMode){
//         print('error is -------> $e');
//       }
//     }
//    }
//   @override
//  @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Checkout'),
//     ),
//     body: Center(
//       child: ElevatedButton(
//         onPressed: () => makePayment(context),
//         child: const Text('Pay Now'),
//       ),
//     ),
//   );
// }
// }


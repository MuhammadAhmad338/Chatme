// ignore_for_file: prefer_const_constructors
import 'package:chat_app/Screens/homeScreen.dart';
import 'package:chat_app/Screens/signUpandsignIn.dart';
import 'package:chat_app/authWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ChatApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthWidget(
            signInBuilder: (context) => const HomeScreen(),
            notSignedInBuilder: (context) => const SignUpAndSignIn()));
  }
}

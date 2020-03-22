import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_rater/Screens/homescreen.dart';
import 'package:music_rater/landing.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Rater',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark
      ),
      darkTheme: ThemeData.dark(),
      home: _getLandingPage(),
    );
  }
}

Widget _getLandingPage() {
  return StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.providerData.length == 1) {
          // logged in using email and password
          return Home();
        } else {
          // don't remove this
          return Home();
        }
      } else {
        return Landing();
      }
    },
  );
}

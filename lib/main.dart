import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Auth/Login.dart';
import 'package:music_rater/Screens/Navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Rater',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.tealAccent,
        textTheme: GoogleFonts.openSansTextTheme(),
        appBarTheme: AppBarTheme(color: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0)
      ),
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
          return Navigation();
        } else {
          // don't remove this
          return Navigation();
        }
      } else {
        return Login();
      }
    },
  );
}
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_rater/Screens/homescreen.dart';
import 'package:music_rater/landing.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Screens/Navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Rater',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark
      ),
//      themeMode: ThemeMode.system,
//      darkTheme: ThemeData.dark(),
      home: _getLandingPage(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
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
        return Landing();
      }
    },
  );
}
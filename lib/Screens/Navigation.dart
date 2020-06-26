import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/Account.dart';
import 'package:music_rater/Screens/addMusic.dart';
import 'package:music_rater/Screens/homescreen.dart';

class Navigation extends StatefulWidget{

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final _selectedPage = [
    Home(),
    AddMusic(),
    Account()
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Viewing on mobile
    if(MediaQuery.of(context).size.width < 600){
      return SafeArea(
        child: Scaffold(
          body: _selectedPage[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            onTap: (int index){
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.black,),
                title: Text("Home", style: GoogleFonts.robotoMono(color: Colors.black),)
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add, color: Colors.black,),
                  title: Text("Add Music", style: GoogleFonts.robotoMono(color: Colors.black))
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, color: Colors.black,),
                  title: Text("Account", style: GoogleFonts.robotoMono(color: Colors.black))
              )
            ],
          ),
        ),
      );
    }
  }
}
import 'package:flutter/cupertino.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index){
                setState(() {
                  _selectedIndex = index;
                });
              },
              leading: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Navigation()));
                      },
                      child: Image.asset('assets/logo.png', width: 50, height: 50,),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Navigation()));
                    },
                    child: Text('Music Rater', style: GoogleFonts.robotoMono(),),
                  )
                ],
              ),
//              labelType: NavigationRailLabelType.selected,
            selectedIconTheme: IconThemeData(color: Colors.teal),
              selectedLabelTextStyle: TextStyle(color: Colors.teal),
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text("Home", style: GoogleFonts.robotoMono(),)
                ),
                NavigationRailDestination(
                    icon: Icon(Icons.add),
                    label: Text("Add Music", style: GoogleFonts.robotoMono(),)
                ),
                NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    label: Text("Account", style: GoogleFonts.robotoMono(),)
                ),
              ],
            ),
            VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: Center(
                child: _selectedPage[_selectedIndex],
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/PostRelated/addMusic.dart';
import 'package:music_rater/Screens/Profile/Account.dart';
import 'package:music_rater/Screens/homescreen.dart';
import 'package:universal_platform/universal_platform.dart';

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

  void _onItemTap(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Viewing on mobile
    if(UniversalPlatform.isAndroid || MediaQuery.of(context).size.width < 600){
      return SafeArea(
        child: Scaffold(
          body: _selectedPage[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note_outlined, color: Colors.grey,),
                activeIcon: Icon(Icons.music_note, color: Colors.teal,),
                label: "Songs"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_outlined, color: Colors.grey,),
                  activeIcon: Icon(Icons.add, color: Colors.teal,),
                  label: "Add Song"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, color: Colors.grey,),
                  activeIcon: Icon(Icons.person, color: Colors.teal,),
                  label: "Account"
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
                  icon: Icon(Icons.music_note_outlined),
                  selectedIcon: Icon(Icons.music_note),
                  label: Text("Songs")
                ),
                NavigationRailDestination(
                    icon: Icon(Icons.add_outlined),
                    selectedIcon: Icon(Icons.add),
                    label: Text("Add Song")
                ),
                NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text("Account")
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('About', style: TextStyle(color: Colors.black),),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.asset('assets/logo.png', scale: 5,),
                ),
                Text('About', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 30)),),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text('Music is a universal language, and everyone listens to it amlost everyday. '
                      'There are so many different songs out there from all over the world, and its '
                      'hard for one person to keep track of all of this, and share it with everyone they might know. '
                      'In order to make that simpler, Music Rater was created. '
                      "It's a free application where users can share any song that's on there mind, "
                      "and seemlesly other users will be able to see the song when they open the application.",
                  style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 20)),),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
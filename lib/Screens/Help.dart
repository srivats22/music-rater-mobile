import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Help extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    TabController tabIndex;
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('Help'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text('Music Cover - Phone', textAlign: TextAlign.center,
                  style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 25)),),
                ),
                SizedBox(height: 5,),
                Text('Step 1: Open Chrome', style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 18))),
                SizedBox(height: 5,),
                Text('Step 2: Search for music cover', style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 18))),
                SizedBox(height: 5,),
                Text('Step 3: Long Press and Click share', style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 18))),
                SizedBox(height: 5,),
                Text('Step 4: Click Copy link to clipboard', style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 18))),
                SizedBox(height: 5,),
                Text('Step 5: Open the app again and past in Music Cover', style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 18))),
                SizedBox(height: 5,),
                Divider(color: Colors.white,),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Music Cover - Desktop', textAlign: TextAlign.center,
                    style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 25)),),
                ),
                SizedBox(height: 5,),
                Text('Step 1: Open Chrome', style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 18))),
                SizedBox(height: 5,),
                Text('Step 2: Search for music cover', style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 18))),
                SizedBox(height: 5,),
                Text('Step 3: Right Click -> copy image address', style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 18))),
                SizedBox(height: 5,),
                Text('Step 4: Past the link in Music Cover', style: GoogleFonts.googleSans(textStyle: TextStyle(fontSize: 18))),
              ],
            ),
          )
        )
      ),
    );
  }
}
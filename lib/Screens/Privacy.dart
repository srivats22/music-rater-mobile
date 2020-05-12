import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Privacy extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text('Privacy', style: GoogleFonts.openSans(),),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(padding: EdgeInsets.only(top: 30), child: Icon(Icons.security, size: 50,),),
              ),
              SizedBox(height: 10,),
              Text('Privacy Policy', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 20)), textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Text('Entertainment Rater is an application where users can share music from anywhere in the world.'),
              Text('We have written this privacy policy in simple english terms, so you can get the important'
                  'information easily'),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  width: 160.0,
                  child: Card(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Text('Information Your Provide', textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20)),),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Text('When creating an account, you were required to enter'
                                ' your email address, and choose a password. '
                                'That is the only thing we ask of you.', textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 18)),),
                          )
                        ],
                      ),
                    )
                  )
                ),
                Container(
                    width: 160.0,
                    child: Card(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            Text('Information We See', textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20)),),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text('When creating an account, you were required to enter'
                                  ' from that we can only see the email address you used'
                                  " while creating the account. We don't see the password you used", textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 18)),),
                            )
                          ],
                        ),
                      )
                    )
                ),
                Container(
                    width: 160.0,
                    child: Card(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Text('Information We Share', textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(fontSize: 20),),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text("Believe it or not, we don't see a need to share any information.", textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(fontSize: 18),),
                            )
                          ],
                        ),
                      )
                    )
                ),
                Container(
                    width: 160.0,
                    child: Card(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Text('Email Policy', textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20))),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text("We don't send out any unnecessary emails. "
                                  "The only email you will recieve from us is, "
                                  "with regards to changing your password.", textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(fontSize: 18),),
                            )
                          ],
                        ),
                      )
                    )
                ),
              ],
            )
          )],
          ),
        ),
      ),
    );
  }
}
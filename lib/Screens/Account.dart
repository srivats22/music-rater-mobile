import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/About.dart';
import 'package:music_rater/Screens/Privacy.dart';
import 'package:url_launcher/url_launcher.dart';
import '../landing.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Account extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountState();
  }
}

class _AccountState extends State<Account>{
  var uid = '';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Account', style: GoogleFonts.openSans(),),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Icon(Icons.person_outline, size: 100,),
                ),
                FutureBuilder(
                  future: FirebaseAuth.instance.currentUser(),
                  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.hasData) {
                      String email = snapshot.data.email;
                      String name = email.substring(0, email.indexOf("@"));
                      return Text(
                        name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(fontSize: 30)),
                      );
                    }
                    return LinearProgressIndicator();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 300,
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Privacy()));
                      },
                      leading: Icon(Icons.security),
                      title: Text('Privacy', style: GoogleFonts.openSans(fontSize: 20),),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  )
                ),
                Container(
                    width: 300,
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                        },
                        leading: Icon(Icons.info),
                        title: Text('About', style: GoogleFonts.openSans(fontSize: 20),),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    )
                ),
                Container(
                    width: 300,
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context){
                              if(kIsWeb && MediaQuery.of(context).size.width < 600){
                                return Container(
                                  height: 500,
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: updates(),
                                  ),
                                );
                              }
                              if(kIsWeb){
                                return Container(
                                  height: 500,
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: updates(),
                                  ),
                                );
                              }
                              return Container(
                                height: 500,
                                child: SingleChildScrollView(
                                  child: updates(),
                                ),
                              );
                            }
                        ),
                        leading: Icon(Icons.new_releases),
                        title: Text("What's New", style: GoogleFonts.openSans(fontSize: 20),),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    )
                ),
                Container(
                    width: 300,
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        onTap: (){
                          if(canLaunch('srivats.venkataraman@gmail.com') != null){
                            launch('mailto:srivats.venkataraman@gmail.com');
                          }
                        },
                        leading: Icon(Icons.email),
                        title: Text('Contact', style: GoogleFonts.openSans(fontSize: 20),),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    )
                ),
                Container(
                    width: 300,
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        onTap: () async{
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
                        },
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout', style: GoogleFonts.openSans(fontSize: 20),),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    )
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget updates(){
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text("What's New", style: GoogleFonts.roboto(fontSize: 25),),
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text('1. A brand new UI has taken over the Home Screen', style: GoogleFonts.robotoMono(fontSize: 20),
            textAlign: TextAlign.center,),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text('2. Dedicated like button', style: GoogleFonts.robotoMono(fontSize: 20),
            textAlign: TextAlign.center,),
        ),
        SizedBox(height: 20,),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text('Stay Tuned for more fun updates', style: GoogleFonts.robotoMono(fontSize: 20)),
        )
      ],
    );
  }

  void signOut() async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => true);
      dispose();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
    }
    catch(e){
      e.toString();
    }
  }
}
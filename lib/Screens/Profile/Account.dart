import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Auth/Login.dart';
import 'package:music_rater/Screens/Privacy.dart';
import 'package:music_rater/Screens/Profile/About.dart';
import 'package:music_rater/Screens/Profile/YourPosts.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AccountState();
  }
}

class _AccountState extends State<Account>{
  String userUid, userEmail, userName;
  FirebaseUser user;

  void getUser() async{
    user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userUid = user.uid;
      userEmail = user.email;
      userName = user.displayName;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text('Account', style: GoogleFonts.openSans(fontSize: 30),),
                  ),
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
                  Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: .5,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Account Related', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                  ),
                  ListTile(
                    onTap: (){},
                    leading: Icon(Icons.edit),
                    title: Text('Edit Profile'),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => YourPosts(userUid: userUid,)));
                    },
                    leading: Icon(Icons.music_note),
                    title: Text('Your Posts'),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: .5,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Account Related', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => About()));
                    },
                    leading: Icon(Icons.info),
                    title: Text('About Music Rater'),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Privacy()));
                    },
                    leading: Icon(Icons.security),
                    title: Text('Privacy'),
                  ),
                  ListTile(
                    onTap: (){
                      showBottomSheet(
                        context: context,
                        builder: (context) {
                          return updates();
                        },
                      );
                    },
                    leading: Icon(Icons.new_releases),
                    title: Text("What's New"),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: .5,
                  ),
                  ListTile(
                    onTap: (){
                      signOut();
                    },
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Logout'),
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
            child: Text("What's New", style: TextStyle(fontSize: 25),),
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text('1. This update has a UI refresh', style: GoogleFonts.robotoMono(fontSize: 20),
            textAlign: TextAlign.center,),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text('2. See your posts', style: GoogleFonts.robotoMono(fontSize: 20),
            textAlign: TextAlign.center,),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text('3. See Others Posts by clicking on a comment or their name in the detail screen', style: GoogleFonts.robotoMono(fontSize: 20),
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
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    }
    catch(e){
      e.toString();
    }
  }
}
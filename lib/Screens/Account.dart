import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/About.dart';
import 'package:music_rater/Screens/Privacy.dart';
import 'package:music_rater/Screens/YourPosts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../landing.dart';

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
          title: Text('Account', style: GoogleFonts.googleSans(),),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Icon(Icons.account_circle, size: 100,),
                ),
                FutureBuilder(
                  future: FirebaseAuth.instance.currentUser(),
                  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.hasData) {
                      String email = snapshot.data.email;
                      return Text(
                        email,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.googleSans(
                            textStyle: TextStyle(fontSize: 40)),
                      );
                    }
                    return LinearProgressIndicator();
                  },
                ),
//                Container(
//                    width: 300,
//                    child: Card(
//                      elevation: 10,
//                      child: ListTile(
//                        onTap: (){
//                          Navigator.push(context, MaterialPageRoute(builder: (context) => YourPosts()));
//                        },
//                        leading: Icon(Icons.list),
//                        title: Text('Your Posts', style: GoogleFonts.googleSans(fontSize: 20),),
//                        trailing: Icon(Icons.arrow_forward),
//                      ),
//                    )
//                ),
                Container(
                  width: 300,
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Privacy()));
                      },
                      leading: Icon(Icons.security),
                      title: Text('Privacy', style: GoogleFonts.googleSans(fontSize: 20),),
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
                        title: Text('About', style: GoogleFonts.googleSans(fontSize: 20),),
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
                        title: Text('Contact', style: GoogleFonts.googleSans(fontSize: 20),),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    )
                ),
                Container(
                    width: 300,
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        onTap: signOut,
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout', style: GoogleFonts.googleSans(fontSize: 20),),
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

  void signOut() async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
    }
    catch(e){
      e.toString();
    }
  }
}
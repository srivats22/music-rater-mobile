import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/addMusic.dart';
import 'package:music_rater/landing.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      'Home',
                      style: GoogleFonts.googleSans(
                          textStyle:
                          TextStyle(color: Colors.white, fontSize: 40)),
                    ),
                  ),
                  Expanded(
                      child: GestureDetector(
                        onTap: _showAccount,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20, top: 20),
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 40,
                              ),
                            )),
                      ))
                ],
              ),
              SizedBox(height: 10,),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Music').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return new ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return new Padding(
                          padding: EdgeInsets.only(left: 30, right: 30),
                        child: Card(
                          color: Color.fromRGBO(136, 255, 255, 1),
                          child: ListTile(
                            onTap: () => showDialog(context: context,
                            child: AlertDialog(
                              content: Container(
                                height: 250,
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.play_circle_filled),
                                    Text(document['musicName'], style: GoogleFonts.googleSans(),),
                                    SizedBox(height: 5,),
                                    Text(document['artistName'], style: GoogleFonts.googleSans(),),
                                    SizedBox(height: 5,),
                                    Text(document['likes'].toString(), style: GoogleFonts.googleSans(),),
                                    SizedBox(height: 5,),
                                    FloatingActionButton.extended(onPressed: (){
                                      var url = document['musicLink'];
                                      if (canLaunch(url) != null) {
                                       launch(url);
                                      } else {
                                      throw 'Could not launch $url';
                                      }
                                       },
                                      label: Text('Play'),
                                      icon: Icon(Icons.play_circle_filled),),
                                    SizedBox(height: 5,),
                                    FloatingActionButton.extended(onPressed: (){
                                      document.reference.updateData({
                                        'likes': document['likes'] + 1
                                      });
                                    },
                                      label: Text('Like'),
                                      icon: Icon(Icons.thumb_up),)
                                  ],
                                ),
                              )
                            )),
                            leading: Icon(Icons.album, color: Colors.black,),
                            title: Text(document['musicName'], style: GoogleFonts.googleSans(textStyle: TextStyle(color: Colors.black)),),
                            subtitle: Text(document['artistName'] + '\nLikes: ' + document['likes'].toString(), style: GoogleFonts.googleSans(textStyle: TextStyle(color: Colors.black)),),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddMusic()));
          },
          backgroundColor: Color.fromRGBO(0, 159, 175, 1),
          label: Text(
            'Add Music',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  //ToDO: add privacy and terms of use
  _showAccount() async {
    await showDialog<String>(
        context: context,
        child: AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 50,
                  ),
                  SizedBox(
                    height: 10,
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
                              textStyle: TextStyle(fontSize: 20)),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Landing()));
                      });
                    },
                    child: Text(
                      'Sign Out',
                      style: GoogleFonts.roboto(),
                    ),
                    color: Colors.white,
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: null,
                        child: Text(
                          'Privacy ',
                          style: GoogleFonts.googleSans(),
                        ),
                      ),
                      Text(
                        ' . ',
                        style: GoogleFonts.googleSans(),
                      ),
                      GestureDetector(
                        onTap: null,
                        child: Text(
                          ' Terms of use',
                          style: GoogleFonts.googleSans(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}

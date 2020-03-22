import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class YourPosts extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _YourPostsState();
  }
}

class _YourPostsState extends State<YourPosts>{
  String userID = '';

  Future<String> userUID() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID = user.uid.toString();
    return userID;
  }

//  getUserUID() async{
//
//  }

  Future getUserPost() async{
    var firestore = Firestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('Music').where('uid', isEqualTo: userID).getDocuments();

    return querySnapshot;
  }

  @override
  Widget build(BuildContext context){
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Your Posts', style: GoogleFonts.googleSans(),),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
//              FutureBuilder(
//                future: FirebaseAuth.instance.currentUser(),
//                builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
//                  if (snapshot.hasData) {
//                    String email = snapshot.data.email;
//                    userID = snapshot.data.uid;
//                    print(userID.toString());
//                    return Text(
//                      email,
//                      textAlign: TextAlign.center,
//                      style: GoogleFonts.googleSans(
//                          textStyle: TextStyle(fontSize: 40)),
//                    );
//                  }
//                  return LinearProgressIndicator();
//                },
//              ),
              SizedBox(height: 10,),
              StreamBuilder(
                stream: Firestore.instance.collection('Music').where('uid', isEqualTo: userUID()).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return Expanded(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 100),
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return new Container(
                          child: new Column(
                            children: <Widget>[
                              Icon(Icons.album, size: 100,),
                              SizedBox(height: 5,),
                              Text(document['musicName'], style: GoogleFonts.googleSans(fontSize: 20),),
                              SizedBox(height: 5,),
                              FlatButton(
                                onPressed: (){
                                  Firestore.instance.runTransaction((transaction) async{
                                    DocumentSnapshot freshSnap =
                                    await transaction.get(document.reference);
                                    await transaction.update(freshSnap.reference, {
                                      'likes': freshSnap['likes'] + 1,
                                    });
                                  });
                                },
                                child: Text('Likes: ' + document['likes'].toString(), style: GoogleFonts.googleSans(fontSize: 20),),
                              ),
                              SizedBox(height: 5,),
                              RaisedButton(
                                onPressed: () => showDialog(
                                    context: context,
                                    child: new AlertDialog(
                                      content: new Container(
                                          height: 300,
                                          child: new Center(
                                            child: new Column(
                                              children: <Widget>[
                                                Icon(Icons.album, size: 100,),
                                                SizedBox(height: 5,),
                                                Text(document['musicName'], style: GoogleFonts.googleSans(fontSize: 20),),
                                                SizedBox(height: 5,),
                                                Text(document['artistName'], style: GoogleFonts.googleSans(fontSize: 20),),
                                                SizedBox(height: 5,),
                                                Text(document['genre'], style: GoogleFonts.googleSans(fontSize: 20),),
                                                SizedBox(height: 5,),
                                                FloatingActionButton.extended(
                                                  heroTag: 'Play Music',
                                                  onPressed: (){
                                                    var url = document['musicLink'];
                                                    if (canLaunch(url) != null) {
                                                      launch(url);
                                                    } else {
                                                      throw 'Could not launch $url';
                                                    }
                                                  },
                                                  label: Text('Play'),
                                                  icon: Icon(Icons.play_circle_filled),),
                                              ],
                                            ),
                                          )
                                      ),
                                    )
                                ),
                                child: Text('More Info'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 50, right: 50),
                                child: Divider(thickness: 1, color: Colors.white,),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
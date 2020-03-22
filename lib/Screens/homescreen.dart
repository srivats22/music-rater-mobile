import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/Account.dart';
import 'package:music_rater/Screens/addMusic.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  TextEditingController image, musicName, artistName, musicLink;
  bool _isLiked = true;
  @override
  void initState() {
    // TODO: implement initState
    image = new TextEditingController();
    musicName = new TextEditingController();
    artistName = new TextEditingController();
    musicLink = new TextEditingController();
    super.initState();
  }

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
                          TextStyle(fontSize: 40)),
                    ),
                  ),
                  Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
                        },
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20, top: 20),
                              child: Icon(
                                Icons.account_circle,
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
                  return Expanded(
                    child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 100),
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                          //no image provided by user
                          if(document['image'].toString().isEmpty){
                            return new Container(
                              child: new Column(
                                children: <Widget>[
                                  Icon(Icons.album, size: 100, color: Colors.white,),
                                  SizedBox(height: 5,),
                                  Text(document['musicName'], style: GoogleFonts.googleSans(fontSize: 20),),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FlatButton(
                                      onPressed: () async{
                                        Firestore.instance.runTransaction((transaction) async {
                                          DocumentSnapshot freshSnap =
                                          await transaction.get(
                                              document
                                                  .reference);
                                          await transaction
                                              .update(freshSnap
                                              .reference, {
                                            'likes': freshSnap['likes'] +
                                                1,
                                          }).whenComplete(() => showDialog(
                                              context: (context),
                                              child: AlertDialog(
                                                content: Container(
                                                  height: 100,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text('You Liked the: ' + document['musicName']),
                                                      OutlineButton(
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Close'),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ));
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.favorite, color: Colors.red,),
                                          Text('Likes: ' + document['likes'].toString(), style: GoogleFonts.googleSans(fontSize: 20),),
                                        ],
                                      ),
                                    ),
                                      SizedBox(width: 10,),
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
                                                        ButtonBar(
                                                          alignment: MainAxisAlignment.center,
                                                          children: <Widget>[
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
                                                      ],
                                                    ),
                                                  )
                                              ),
                                            )
                                        ),
                                        child: Text('More Info'),
                                      ),],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 50, right: 50),
                                    child: Divider(thickness: 1, color: Colors.white,),
                                  )
                                ],
                              ),
                            );
                          }
                          //image provided by  user
                          var docId = snapshot.data;
                          return new Container(
                            child: new Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: NetworkImage(document['image']),
                                  radius: 50,
                                ),
                                SizedBox(height: 5,),
                                Text(document['musicName'], style: GoogleFonts.googleSans(fontSize: 20),),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                    onPressed: () async{
                                      Firestore.instance.runTransaction((transaction) async {
                                        DocumentSnapshot freshSnap =
                                        await transaction.get(
                                            document
                                                .reference);
                                        await transaction
                                            .update(freshSnap
                                            .reference, {
                                          'likes': freshSnap['likes'] +
                                              1,
                                        }).whenComplete(() => showDialog(
                                            context: (context),
                                            child: AlertDialog(
                                              content: Container(
                                                height: 100,
                                                child: Column(
                                                  children: <Widget>[
                                                    Text('You Liked the: ' + document['musicName']),
                                                    OutlineButton(
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Close'),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                        ));
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.favorite, color: Colors.red,),
                                        Text('Likes: ' + document['likes'].toString(), style: GoogleFonts.googleSans(fontSize: 20),),
                                      ],
                                    ),
                                  ),
                                    SizedBox(width: 10,),
                                    RaisedButton(
                                      onPressed: () => showDialog(
                                          context: context,
                                          child: new AlertDialog(
                                            content: new Container(
                                                height: 300,
                                                child: new Center(
                                                  child: new Column(
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        backgroundImage: NetworkImage(document['image']),
                                                        radius: 50,
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text(document['musicName'], style: GoogleFonts.googleSans(fontSize: 20),),
                                                      SizedBox(height: 5,),
                                                      Text(document['artistName'], style: GoogleFonts.googleSans(fontSize: 20),),
                                                      SizedBox(height: 5,),
                                                      Text(document['genre'], style: GoogleFonts.googleSans(fontSize: 20),),
                                                      SizedBox(height: 5,),
                                                      ButtonBar(
                                                        alignment: MainAxisAlignment.center,
                                                        children: <Widget>[
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
                                                    ],
                                                  ),
                                                )
                                            ),
                                          )
                                      ),
                                      child: Text('More Info'),
                                    ),],
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
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'Add Music',
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
}

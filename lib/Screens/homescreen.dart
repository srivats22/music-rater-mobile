import 'package:cloud_firestore/cloud_firestore.dart';
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
                      style: GoogleFonts.openSans(
                          textStyle:
                          TextStyle(fontSize: 40)),
                    ),
                  ),
                  Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20, top: 20),
                          child: IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
                            },
                            icon: Icon(Icons.account_circle),
                            iconSize: 40,
                            tooltip: 'Account',
                          )
                      )),
                  )],
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
                                  Text(document['musicName'], style: GoogleFonts.openSans(fontSize: 20),),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      OutlineButton(
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
                                                      Text('You Liked: ' + document['musicName']),
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
                                          Text('Likes: ' + document['likes'].toString(), style: GoogleFonts.openSans(fontSize: 20),),
                                        ],
                                      ),
                                    ),
                                      SizedBox(width: 10,),
                                      OutlineButton(
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
                                                        Text(document['musicName'], style: GoogleFonts.openSans(fontSize: 20),),
                                                        SizedBox(height: 5,),
                                                        Text(document['artistName'], style: GoogleFonts.openSans(fontSize: 20),),
                                                        SizedBox(height: 5,),
                                                        Text(document['genre'], style: GoogleFonts.openSans(fontSize: 20),),
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
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.info),
                                            Text('More Info')
                                          ],
                                        ),
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
                          return new Container(
                            child: new Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: NetworkImage(document['image']),
                                  radius: 50,
                                ),
                                SizedBox(height: 5,),
                                Text(document['musicName'], style: GoogleFonts.openSans(fontSize: 20),),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    OutlineButton(
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
                                                    Text('You Liked: ' + document['musicName']),
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
                                        Text('Likes: ' + document['likes'].toString(), style: GoogleFonts.openSans(fontSize: 20),),
                                      ],
                                    ),
                                  ),
                                    SizedBox(width: 10,),
                                    OutlineButton(
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
                                                      Text(document['musicName'], style: GoogleFonts.openSans(fontSize: 20),),
                                                      SizedBox(height: 5,),
                                                      Text(document['artistName'], style: GoogleFonts.openSans(fontSize: 20),),
                                                      SizedBox(height: 5,),
                                                      Text(document['genre'], style: GoogleFonts.openSans(fontSize: 20),),
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
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.info),
                                          Text('More Info')
                                        ],
                                      ),
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
          tooltip: 'Add Music',
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

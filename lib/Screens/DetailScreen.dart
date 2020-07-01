import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailScreen extends StatefulWidget{
  final musicID, musicName, artistName, genre, musicUrl;

  var rating;

  DetailScreen({@required this.musicID, this.musicName, this.artistName, this.genre, this.musicUrl, this.rating = 0.0});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailScreenState();
  }
}

class _DetailScreenState extends State<DetailScreen>{
  String name;
  TextEditingController comment;
  FirebaseUser currentUser;
  String uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comment = new TextEditingController();
    this.getCurrentUser();
  }

  void getCurrentUser() async{
    currentUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = currentUser.uid;
      String email = currentUser.email;
      name = email.substring(0, email.indexOf("@"));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(widget.musicName, style: GoogleFonts.roboto(),),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Icon(Icons.music_note, color: Colors.white, size: 30,),
                    Text(widget.musicName, style: GoogleFonts.robotoMono(color: Colors.white),),
                    Text(widget.artistName, style: GoogleFonts.robotoMono(color: Colors.white),),
                    Text(widget.genre, style: GoogleFonts.robotoMono(color: Colors.white),),
                    RaisedButton(
                      onPressed: (){
                        if(canLaunch(widget.musicUrl) != null){
                          launch(widget.musicUrl);
                        }
                      },
                      child: Text('Listen'),
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: .5,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 258,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('MusicTestDB')
                          .document(widget.musicID).collection('rating').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(!snapshot.hasData){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if(snapshot.data.documentChanges.isEmpty){
                          return Center(
                            child: Text('No Ratings yet'),
                          );
                        }
                        return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index){
                              DocumentSnapshot data = snapshot.data.documents[index];
                              return Column(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * .90,
                                      child: Card(
                                        elevation: 10,
                                        child: ListTile(
                                          isThreeLine: true,
                                          leading: Icon(Icons.star),
                                          title: Text(data['name']),
                                          subtitle: Text(data['comment'] + "\nRating: " + data['rating'] +
                                              "\n" + timeago.format(DateTime.tryParse(data['timeStamp'].toDate().toString())).toString()),
                                        ),
                                      )
                                  )
                                ],
                              );
                            }
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            showDialog(
                context: (context),
                child: AlertDialog(
                  content: Container(
                    height: 200,
                    child: Column(
                      children: [
                        startRating(),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Comments"
                          ),
                          maxLength: 256,
                          controller: comment,
                        ),
                        RaisedButton(
                          onPressed: (){
                            final music = Firestore.instance.collection('MusicTestDB')
                                .document(widget.musicID);
                            final rating = music.collection('rating').document();
                            rating.setData({
                              'uid' : uid.toString(),
                              'name' : name.toString(),
                              'rating' : widget.rating.toString(),
                              'comment' : comment.text,
                              'timeStamp' : FieldValue.serverTimestamp(),
                            }).then((value) => Navigator.pop(context));
                          },
                          child: Text('Post'),
                        )
                      ],
                    ),
                  ),
                )
            );
          },
          label: Text('Rate'),
          icon: Icon(Icons.star),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget startRating(){
    return SmoothStarRating(
      onRated: (v){
        setState(() {
          widget.rating = v;
        });
        debugPrint(widget.rating.toString());
      },
      allowHalfRating: true,
      starCount: 5,
      rating: widget.rating,
      color: Colors.teal,
      borderColor: Colors.teal,
      size: 24,
    );
  }
}
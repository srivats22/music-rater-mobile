import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class WebScreen extends StatefulWidget {
  final musicID, musicName, artistName, genre, musicUrl;

  var rating;

  WebScreen({this.musicID, this.musicName, this.artistName, this.genre, this.musicUrl, this.rating = 0.0});
  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          title: Text(widget.musicName, style: TextStyle(color: Colors.black),),
        ),
        body: Row(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Music Name: ${widget.musicName}'),
                    Text('Artist Name: ${widget.artistName}'),
                    Text('Genre: ${widget.genre}'),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.teal,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              onPressed: (){
                                if(canLaunch(widget.musicUrl) != null){
                                  launch(widget.musicUrl);
                                }
                              },
                              icon: Icon(Icons.headset),
                              tooltip: 'Listen',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.teal,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
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
                                                final music = Firestore.instance.collection('Music')
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
                              icon: Icon(Icons.star),
                              tooltip: 'Rate Music',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: Firestore.instance.collection('Music')
                    .document(widget.musicID).collection('rating').getDocuments(),
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
                                    onTap: (){
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context){
                                            return Container(
                                              height: MediaQuery.of(context).size.height * 0.5,
                                              child: Column(
                                                children: [
                                                  Text("Posts By: " + data['name'], style: TextStyle(fontSize: 18),),
                                                  SizedBox(height: 10,),
                                                  Expanded(
                                                    child: usersPost(data['uid']),
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                      );
                                    },
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
        ),
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

  StreamBuilder usersPost(String userUid){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Music')
          .where("id", isEqualTo: userUid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.data.documentChanges.isEmpty){
          return Center(
            child: Text('User does not have any posts!'),
          );
        }
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              DocumentSnapshot data = snapshot.data.documents[index];
              return SizedBox(
                  width: MediaQuery.of(context).size.width * .90,
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      isThreeLine: true,
                      leading: Icon(Icons.music_note, color: Colors.black,),
                      title: Text(data['musicName'], style: GoogleFonts.roboto(color: Colors.black),),
                      subtitle: Text(data['artistName'] +
                          "\nPosted: " + timeago.format(DateTime.tryParse(data['posted_on'].toDate().toString())).toString(), style: GoogleFonts.robotoMono(color: Colors.black),),
                    ),
                  )
              );
            }
        );
      },
    );
  }
}

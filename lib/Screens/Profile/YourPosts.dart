import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/PostRelated/EditPost.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class YourPosts extends StatefulWidget{
  final String userUid;
  YourPosts({this.userUid});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _YourPostsState();
  }
}

class _YourPostsState extends State<YourPosts>{
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Your Posts', style: GoogleFonts.openSans(color: Colors.black),),
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("Music").where("id", isEqualTo: widget.userUid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    DocumentSnapshot data = snapshot.data.documents[index];
                    var id = data.documentID;
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 10, right: 20),
                          isThreeLine:true,
                          leading: Icon(Icons.music_note, color: Colors.black,),
                          title: Text(data['musicName'], style: GoogleFonts.roboto(color: Colors.black),),
                          subtitle: Text(data['artistName'] +
                              "\nPosted: " + timeago.format(DateTime.tryParse(data['posted_on'].toDate().toString())).toString(), style: GoogleFonts.robotoMono(color: Colors.black),),
                          trailing: IconButton(
                            onPressed: (){
                              return showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      content: Container(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            Text("Options", style: TextStyle(fontWeight: FontWeight.bold),),
                                            ButtonBar(
                                              alignment: MainAxisAlignment.center,
                                              children: [
                                                RaisedButton(
                                                  onPressed: (){
                                                    Firestore.instance.collection("Music").document(id)
                                                        .delete();
                                                    Fluttertoast.showToast(msg: "Song Deleted", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
                                                  },
                                                  child: Text("DELETE", style: TextStyle(color: Colors.white),),
                                                  color: Colors.red,
                                                ),
                                                RaisedButton(
                                                  onPressed: (){
                                                    Navigator.of(context)
                                                        .push(new MaterialPageRoute(builder: (context) => EditPost(docId: id
                                                      , musicName: data['musicName'], musicLink: data['musicLink'],
                                                    artistName: data['artistName'], genre: data['genre'],)));
                                                  },
                                                  child: Text("Edit post", style: TextStyle(color: Colors.black),),
                                                  color: Colors.teal,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              );
                            },
                            icon: Icon(Icons.more_vert),
                            color: Colors.black,
                          ),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                          indent: 20,
                          endIndent: 20,
                        )
                      ],
                    );
                  }
              );
            },
          ),
        ),
      ),
    );
  }
}
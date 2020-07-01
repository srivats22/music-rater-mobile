import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/Navigation.dart';
import 'package:music_rater/Screens/homescreen.dart';

class AddMusic extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddMusicState();
  }
}

class _AddMusicState extends State<AddMusic>{
  TextEditingController image, musicName, genre, artistName, musicLink;
  FirebaseUser currentUser;
  String uid;

  void getCurrentUser() async{
    currentUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = currentUser.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    image = new TextEditingController();
    musicName = new TextEditingController();
    genre = new TextEditingController();
    artistName = new TextEditingController();
    musicLink = new TextEditingController();
    this.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text('Add Music', style: GoogleFonts.openSans(fontSize: 30),),
                  ),
                ),
                //Music Name
                Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                      labelText: 'Music Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0, 
                          style: BorderStyle.none,
                          color: Colors.white
                        ),
                      ),
                    ),
                    controller: musicName,
                  ),
                ),
                //Genre
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Music Genre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                            color: Colors.white
                        ),
                      ),
                    ),
                    controller: genre,
                  ),
                ),
                //Artist Name
                Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                      labelText: 'Artist Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0, 
                          style: BorderStyle.none,
                          color: Colors.white
                        ),
                      ),
                    ),
                    controller: artistName,
                  ),
                ),
                //Music Link
                Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                      labelText: 'Music Link',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0, 
                          style: BorderStyle.none,
                          color: Colors.white
                        ),
                      ),
                    ),
                    controller: musicLink,
                  ),
                ),
                RaisedButton(
                  color: Color.fromRGBO(0, 159, 175, 1),
                      onPressed: (){
                    if(musicName.text.isNotEmpty &&
                        genre.text.isNotEmpty && artistName.text.isNotEmpty
                        && musicLink.text.isNotEmpty){
                      List<String> musicNameSplit = musicName.text.split(" ");
                      List<String> artistNameSplit = artistName.text.split(" ");
                      List<String> musicSearch = [];
                      List<String> artistSearch = [];

                      for(int i = 0; i < musicNameSplit.length; i++){
                        for(int k = 1; k < musicNameSplit[i].length + 1; k++){
                          musicSearch.add(musicNameSplit[i].substring(0, k).toLowerCase());
                        }
                      }

                      for(int i = 0; i < artistNameSplit.length; i++){
                        for(int k = 1; k < artistNameSplit[i].length + 1; k++){
                          artistSearch.add(artistNameSplit[i].substring(0, k).toLowerCase());
                        }
                      }

                      Firestore.instance.collection('Music').add({
                        "musicName" : musicName.text,
                        "musicSearch" : musicSearch,
                        "genre" : genre.text,
                        "artistName" : artistName.text,
                        "artistSearch" : artistSearch,
                        "musicLink" : musicLink.text,
                        "posted_on" : FieldValue.serverTimestamp(),
                        "id": uid.toString()
                      }).then((value) => Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => Navigation())));
                    }
                    else{
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('Error'),
                          content: Container(
                            height: 100,
                            child: Column(
                              children: <Widget>[
                                Text('Fields cannot be empty, please fix the error and try again',
                                  style: GoogleFonts.openSans(),),
                                SizedBox(height: 5,),
                                OutlineButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'),
                                )
                              ],
                            )
                          ),
                        )
                      );
                    }
                    },
                  child: Text('Add Music'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
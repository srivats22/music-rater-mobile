import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/homescreen.dart';

class AddMusic extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddMusicState();
  }
}

class _AddMusicState extends State<AddMusic>{
  TextEditingController musicName, artistName, musicLink;

  @override
  void initState() {
    // TODO: implement initState
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Add Music', style: GoogleFonts.googleSans(),),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Music Name',
                ),
                controller: musicName,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Artist Name'),
                controller: artistName,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Music Link'),
                controller: musicLink,
              ),
            ),
            RaisedButton(
              onPressed: (){
                Firestore.instance.collection('Music').add({
                  "musicName" : musicName.text,
                  "artistName" : artistName.text,
                  "musicLink" : musicLink.text,
                  "likes": 0
                }).then((result) => Navigator.push(context, MaterialPageRoute(builder: (context) => Home())));
              },
              child: Text('Add Music'),
            )
          ],
        )
      ),
    );
  }
}
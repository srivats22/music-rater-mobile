import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/Navigation.dart';

class AddMusic extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddMusicState();
  }
}

class _AddMusicState extends State<AddMusic>{
  TextEditingController musicName, genre, artistName, musicLink;
  String visibilityOption = "True";
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text('Add Song', style: GoogleFonts.openSans(fontSize: 30),),
                ),
              ),
              //Music Name
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: TextFormField(
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
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Visibility', style: TextStyle(fontSize: 20),),
                        ),
                        IconButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  content: Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        Text('Setting visibility to true will show this song on your profile, and those who click on you name can see it'),
                                        OutlinedButton(
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Close'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            );
                          },
                          icon: Icon(Icons.help),
                        ),
                      ],
                    ),
                    DropdownButton(
                      value: visibilityOption,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      underline: Container(
                        height: 2,
                        color: Colors.teal,
                      ),
                      onChanged: (String newVal){
                        setState(() {
                          visibilityOption = newVal;
                        });
                      },
                      items: <String>['True', 'False']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              RaisedButton(
                color: Colors.teal,
                onPressed: (){
                  if(musicName.text.isNotEmpty &&
                      genre.text.isNotEmpty && artistName.text.isNotEmpty
                      && musicLink.text.isNotEmpty){
                    List<String> musicNameSplit = musicName.text.split(" ");
                    List<String> musicSearch = [];

                    for(int i = 0; i < musicNameSplit.length; i++){
                      for(int k = 1; k < musicNameSplit[i].length + 1; k++){
                        musicSearch.add(musicNameSplit[i].substring(0, k).toLowerCase());
                      }
                    }

                    Firestore.instance.collection('Music').add({
                      "musicName" : musicName.text,
                      "musicSearch" : musicSearch,
                      "genre" : genre.text,
                      "artistName" : artistName.text,
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
    );
  }
}
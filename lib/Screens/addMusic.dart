import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController image, musicName, genre, artistName, musicLink;

  @override
  void initState() {
    // TODO: implement initState
    image = new TextEditingController();
    musicName = new TextEditingController();
    genre = new TextEditingController();
    artistName = new TextEditingController();
    musicLink = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var height = MediaQuery.of(context).size.height;
    var uid;
    FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          uid = snapshot.data.uid.toString();
        }
        return LinearProgressIndicator();
      },
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Add Music', style: GoogleFonts.googleSans(),),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Album Cover
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Album Cover (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                            color: Colors.white
                        ),
                      ),
                    ),
                    controller: image,
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
                        "image" : image.text,
                        "musicName" : musicName.text,
                        "musicSearch" : musicSearch,
                        "genre" : genre.text,
                        "artistName" : artistName.text,
                        "artistSearch" : artistSearch,
                        "musicLink" : musicLink.text,
                        "likes": 0,
                        "id": uid
                      }).then((result) => Navigator.push(context, MaterialPageRoute(builder: (context) => Home())));
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
                                  style: GoogleFonts.googleSans(),),
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
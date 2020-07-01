import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/Account.dart';
import 'package:music_rater/Screens/DetailScreen.dart';
import 'package:music_rater/Screens/addMusic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  FirebaseUser currentUser;
  bool isDoubleTapped = false;
  String searchFilter = "";

  void initialSearch(String val) {
    setState(() {
      searchFilter = val.toLowerCase().trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Mobile view
    if(MediaQuery.of(context).size.width < 600){
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text('Home', style: GoogleFonts.openSans(fontSize: 30),),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Search Music Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)
                      )),
                    onChanged: (val) => initialSearch(val)
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height - 250,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (searchFilter == null || searchFilter.trim() == "") ?
                    Firestore.instance.collection("Music").snapshots() :
                    Firestore.instance.collection("Music").where('musicSearch', arrayContains: searchFilter).snapshots(),
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
                                  onTap: (){
                                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailScreen(
                                      musicID: id, musicName: data['musicName'],
                                      artistName: data['artistName'], genre: data['genre'], musicUrl: data['musicLink'],)));
                                  },
                                  leading: Icon(Icons.music_note, color: Colors.white,),
                                  title: Text(data['musicName'], style: GoogleFonts.roboto(color: Colors.white),),
                                  subtitle: Text(data['artistName'], style: GoogleFonts.robotoMono(color: Colors.white),),
                                  trailing: IconButton(
                                    onPressed: (){
                                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailScreen(
                                        musicID: id, musicName: data['musicName'],
                                        artistName: data['artistName'], genre: data['genre'], musicUrl: data['musicLink'],)));
                                    },
                                    icon: Icon(Icons.arrow_forward, color: Colors.white,),
                                  ),
                                ),
                                Divider(
                                  thickness: .5,
                                  color: Colors.white,
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
              )
            ],
          ),
        ),
      );
    }
    //Web
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text('Home', style: GoogleFonts.openSans(fontSize: 30),),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Search Music Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)
                    )),
                  onChanged: (val) => initialSearch(val)
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height - 172,
                child: StreamBuilder<QuerySnapshot>(
                    stream: (searchFilter == null || searchFilter.trim() == "") ?
                    Firestore.instance.collection("Music").snapshots() :
                    Firestore.instance.collection("Music").where('musicSearch', arrayContains: searchFilter).snapshots(),
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
                                onTap: (){
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailScreen(
                                    musicID: id, musicName: data['musicName'],
                                    artistName: data['artistName'], genre: data['genre'], musicUrl: data['musicLink'],)));
                                },
                                leading: Icon(Icons.music_note, color: Colors.white,),
                                title: Text(data['musicName'], style: GoogleFonts.roboto(color: Colors.white),),
                                subtitle: Text(data['artistName'], style: GoogleFonts.robotoMono(color: Colors.white),),
                                trailing: IconButton(
                                  onPressed: (){
                                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailScreen(
                                      musicID: id, musicName: data['musicName'],
                                      artistName: data['artistName'], genre: data['genre'], musicUrl: data['musicLink'],)));
                                  },
                                  icon: Icon(Icons.arrow_forward, color: Colors.white,),
                                ),
                              ),
                              Divider(
                                thickness: .5,
                                color: Colors.white,
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
            )
          ],
        ),
      ),
    );
  }
}

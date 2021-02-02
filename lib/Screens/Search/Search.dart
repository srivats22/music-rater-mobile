import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/DetailScreen/DetailScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchFilter = "";

  void initialSearch(String val) {
    setState(() {
      searchFilter = val.toLowerCase().trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width * .80,
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black,),
                  ),
                  hintText: 'Search By Music Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  filled: true,
                ),
                autofocus: true,
                onChanged: (val) => initialSearch(val),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: (searchFilter == null || searchFilter.trim() == "") ?
                Firestore.instance.collection("Music").snapshots() :
                Firestore.instance.collection("Music").where('musicSearch', arrayContains: searchFilter.toLowerCase()).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .75,
                        child: LinearProgressIndicator(),
                      ),
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
                              onTap: (){
                                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailScreen(
                                  musicID: id, musicName: data['musicName'],
                                  artistName: data['artistName'], genre: data['genre'], musicUrl: data['musicLink'],)));
                              },
                              leading: ExcludeSemantics(
                                child: CircleAvatar(
                                  child: Text('${index+1}'),
                                ),
                              ),
                              title: Text(data['musicName'], style: GoogleFonts.roboto(color: Colors.black),),
                              subtitle: Text(data['artistName'] +
                                  "\nPosted: " + timeago.format(DateTime.tryParse(data['posted_on'].toDate().toString())).toString(), style: GoogleFonts.robotoMono(color: Colors.black),),
                              trailing: IconButton(
                                onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          content: Container(
                                            height: 200,
                                            child: SingleChildScrollView(
                                              physics: BouncingScrollPhysics(),
                                              child: Column(
                                                children: [
                                                  Text('Options', textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                                  ListTile(
                                                    onTap: (){
                                                      if(canLaunch(data['musicLink']) != null){
                                                        launch(data['musicLink']);
                                                      }
                                                    },
                                                    leading: Icon(Icons.headset, color: Colors.teal,),
                                                    title: Text('Listen to: ${data['musicName']}', overflow: TextOverflow.ellipsis,),
                                                  ),
                                                  Divider(
                                                    indent: 20,
                                                    endIndent: 20,
                                                  ),
                                                  ListTile(
                                                    onTap: (){
                                                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailScreen(
                                                        musicID: id, musicName: data['musicName'],
                                                        artistName: data['artistName'], genre: data['genre'], musicUrl: data['musicLink'],)));
                                                    },
                                                    leading: Icon(Icons.comment, color: Colors.teal,),
                                                    title: Text('View Comments'),
                                                  ),
                                                  OutlineButton(
                                                    onPressed: (){
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Close'),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                icon: Icon(Icons.more_vert, color: Colors.black,),
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
            )
          ],
        ),
      ),
    );
  }
}

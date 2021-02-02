import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/Screens/DetailScreen/DetailScreen.dart';
import 'package:music_rater/Screens/Search/Search.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
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
    //Mobile view
    if(MediaQuery.of(context).size.width < 600){
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text('Songs', style: GoogleFonts.openSans(fontSize: 30),),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .90,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Search()));
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))
                        )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: PaginateFirestore(
                  itemBuilderType: PaginateBuilderType.listView,
                  initialLoader: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      child: LinearProgressIndicator(),
                    ),
                  ),
                  itemsPerPage: 10,
                  itemBuilder: (index, context, data) => Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 10, right: 20),
                        isThreeLine:true,
                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailScreen(
                            musicID: data.documentID, musicName: data['musicName'],
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
                                                  musicID: data.documentID, musicName: data['musicName'],
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
                  ),
                  query: Firestore.instance.collection("Music").orderBy("posted_on", descending: true),
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
            Expanded(
              child: PaginateFirestore(
                itemBuilderType: PaginateBuilderType.listView,
                initialLoader: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: LinearProgressIndicator(),
                  ),
                ),
                itemsPerPage: 10,
                itemBuilder: (index, context, data) => Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 10, right: 20),
                      isThreeLine:true,
                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailScreen(
                          musicID: data.documentID, musicName: data['musicName'],
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
                                                musicID: data.documentID, musicName: data['musicName'],
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
                ),
                query: Firestore.instance.collection("Music").orderBy("posted_on", descending: true),
              ),
            )
          ],
        ),
      ),
    );
  }
}

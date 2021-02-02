import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPost extends StatefulWidget {
  final String docId, musicName, genre, artistName, musicLink, isPublic;

  EditPost({this.docId, this.musicName, this.genre, this.artistName, this.musicLink, this.isPublic});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  TextEditingController genre, artistName;
  String visibilityOption = "True";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genre = new TextEditingController();
    genre.text = widget.genre;
    artistName  = new TextEditingController();
    artistName.text = widget.artistName;
    widget.isPublic != null ? visibilityOption = widget.isPublic : visibilityOption = "True";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Music'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${widget.musicName}'),
                Text('${widget.artistName}'),
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
                  child: DropdownButton(
                    value: visibilityOption,
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
                  ),
                ),
                RaisedButton(
                  color: Colors.teal,
                  onPressed: (){
                    if(genre.text.isNotEmpty && artistName.text.isNotEmpty){
                      Firestore.instance.collection("Music")
                          .document(widget.docId).updateData({
                        "genre": genre.text,
                        "artist": artistName.text,
                        "public": visibilityOption
                      });
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
                  child: Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

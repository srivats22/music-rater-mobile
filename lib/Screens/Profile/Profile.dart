import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController email, name;
  FirebaseUser user;
  String userUid, userEmail, userName;
  bool isLoading = false;

  void getCurrUser() async{
    user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userUid = user.uid;
      userEmail = user.email;
      userName = user.displayName;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrUser();
    email = new TextEditingController();
    name = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Edit Profile"),
          elevation: 0,
          // bottom: PreferredSize(
          //   preferredSize: Size(double.infinity, 1.0),
          //   child: isLoading ? LinearProgressIndicator() : null,
          // ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            RaisedButton(
              onPressed: (){
                setState(() {
                  isLoading = true;
                });
                Firestore.instance.collection("users")
                    .document(userUid).setData({
                  "name": name.text,
                  "email": email.text,
                  "uid": userUid
                });
                UserUpdateInfo info = UserUpdateInfo();
                info.displayName = name.text;
                user.updateProfile(info);
                setState(() {
                  isLoading = false;
                });
                Fluttertoast.showToast(
                  msg: "Information updated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER
                );
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}

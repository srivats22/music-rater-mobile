import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_rater/Screens/Navigation.dart';
import 'package:universal_platform/universal_platform.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _signUpKey = new GlobalKey<FormState>();
  TextEditingController email, pwd, name;
  bool isLoading = false;
  String profileType = "Public";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = new TextEditingController();
    pwd = new TextEditingController();
    name = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double _widthScreen = MediaQuery.of(context).size.width;
    if (_widthScreen <= 767.0) {
      return _smallDisplay(); //Mobile
    }
    return _bigDisplay();
  }

  Widget _smallDisplay(){
    return SafeArea(
      child: Scaffold(
          body: isLoading ? CircularProgressIndicator()
              : Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                Image.asset('assets/logo.png', width: 75, height: 75,),
                Text('Music Rater', textAlign: TextAlign.center,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text('A platform for rating music',
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Form(
                  key: _signUpKey,
                  child: Column(
                    children: [
                      Text("Sign Up"),
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsets.all(10),
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
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsets.all(10),
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
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: pwd,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Must be 6+ characters',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 5,),
                      SizedBox(height: 5,),
                      RaisedButton(
                        onPressed: (){
                          setState(() {
                            isLoading = true;
                          });
                          signUp();
                        },
                        child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                        color: Colors.teal,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  Widget _bigDisplay(){
    return SafeArea(
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo.png', width: 100, height: 100,),
                    SizedBox(height: 5,),
                    Text('Music Rater', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text('A platform for rating music', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),)
                  ],
                ),
              ),
            ),
            VerticalDivider(
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: Center(
                child: isLoading ? CircularProgressIndicator() : Form(
                  key: _signUpKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),
                      Text("Sign Up", style: TextStyle(fontSize: 20),),
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsets.all(10),
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
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsets.all(10),
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
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: pwd,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Must be 6+ characters',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 5,),
                      RaisedButton(
                        onPressed: (){
                          setState(() {
                            isLoading = true;
                          });
                          signUp();
                        },
                        child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void signUp() async{
    if(_signUpKey.currentState.validate()){
      _signUpKey.currentState.save();
      try{
        FirebaseUser user =  (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: pwd.text)).user;
        UserUpdateInfo info = new UserUpdateInfo();
        info.displayName = name.text;
        user.updateProfile(info);

        Navigator.of(context)
            .pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => Navigation()),
                (route) => route.isFirst
        );
      }
      catch(e){
        setState(() {
          isLoading = false;
        });
        print(e.toString());
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_rater/Auth/ForgotPassword.dart';
import 'package:music_rater/Auth/SignUp.dart';
import 'package:music_rater/Screens/Navigation.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginKey = new GlobalKey<FormState>();
  TextEditingController email, pwd;
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = new TextEditingController();
    pwd = new TextEditingController();
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
                Image.asset('assets/logo.png', width: 75, height: 75,),
                Text('Music Rater', textAlign: TextAlign.center,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text('A platform for rating music',
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Form(
                  key: _loginKey,
                  child: Column(
                    children: [
                      Text("Login", style: TextStyle(fontSize: 20),),
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
                      Text(isError ? "Error logging in, check email and pwd" : "", style: TextStyle(color: Colors.red),),
                      SizedBox(height: 5,),
                      RaisedButton(
                        onPressed: (){
                          setState(() {
                            isLoading = true;
                          });
                          login();
                        },
                        child: Text('Login'),
                      ),
                      Divider(indent: 20, endIndent: 20,),
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => SignUp()));
                        },
                        child: Text('New? Create Account'),
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
                  key: _loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login", style: TextStyle(fontSize: 20),),
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: email,
                          validator: (input){
                            if(input.isEmpty){
                              return 'Cannot be empty';
                            }
                            return null;
                          },
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
                          validator: (input){
                            if(input.isEmpty){
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          onPressed: (){
                            Navigator.of(context)
                                .push(new MaterialPageRoute(builder: (context) => ForgotPassword()));
                          },
                          child: Text('Forgot Password?'),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(isError ? "Error logging in, check email and password" : "", style: TextStyle(color: Colors.red),),
                      SizedBox(height: 5,),
                      RaisedButton(
                        onPressed: (){
                          setState(() {
                            isLoading = true;
                          });
                          login();
                        },
                        child: Text('Login', style: TextStyle(color: Colors.white),),
                        color: Colors.teal,
                      ),
                      Divider(indent: 20, endIndent: 20,),
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => SignUp()));
                        },
                        child: Text('New? Create Account'),
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

  void login() async{
    if(_loginKey.currentState.validate()){
      _loginKey.currentState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: pwd.text)).user;
        if(user != null){
          Navigator.of(context)
              .pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => Navigation()),
                  (route) => route.isFirst
          );
        }
        else{
          setState(() {
            print("Via Else");
            isLoading = false;
            isError = true;
          });
        }
      }
      catch(e){
        print("Via catch");
        setState(() {
          isLoading = false;
          isError = true;
        });
        print(e.toString());
      }
    }
  }
}

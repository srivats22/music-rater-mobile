import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_rater/Screens/homescreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Landing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LandingState();
  }
}

class _LandingState extends State<Landing> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _loginForm,
                  child: Text('Login'),
                ),
                RaisedButton(
                  onPressed: _createAccountForm,
                  child: Text('Create Account'),
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text('Google Signin'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    Alert(
        context: context,
        title: "LOGIN",
        content: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide an Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                onSaved: (input) => _email = input.trimRight(),
              ),
              TextFormField(
                validator: (input) {
                  if (input.length < 6) {
                    return 'Password has to be atleast 6 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: signIn,
            child: Text(
              "LOGIN",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
    return null;
  }

  Widget _createAccountForm() {
    Alert(
        context: context,
        title: "Create Account",
        content: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide an Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                onSaved: (input) => _email = input,
              ),
              TextFormField(
                validator: (input) {
                  if (input.length < 6) {
                    return 'Password has to be atleast 6 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: createAccount,
            child: Text(
              "Create Account",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
    return null;
  }

  void signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  void createAccount() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Fluttertoast.showToast(
            msg: "Account Created",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}

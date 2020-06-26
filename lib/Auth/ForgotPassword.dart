import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_rater/landing.dart';

class ForgotPassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Forgot Password', style: GoogleFonts.openSans(),),
        ),
        body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text('Forgot Password? No issues', style: GoogleFonts.robotoMono(),),
                  ),
                  Text('Fill out the form below', style: GoogleFonts.robotoMono(),),
                  Padding(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Provide an Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                        onSaved: (input) => _email = input,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: forgotPassword,
                    color: Colors.black,
                    child: Text('Submit', style: GoogleFonts.robotoMono(),),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
  void forgotPassword() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        showDialog<String>(
            context: context,
            child:AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: Container(
                height: 100,
                child: Column(
                  children: <Widget>[
                    Text("Email with link has been sent, don't forget to check your spam"),
                    OutlineButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Landing()));
                      },
                      child: Text('Go Back'),
                    )
                  ],
                )
              )
            ));
      } catch (e) {
        print(e);
      }
    }
  }
}
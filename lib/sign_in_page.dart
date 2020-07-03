import 'dart:io' show Platform;

import 'package:ffa_app/auth_service.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  bool _obscureTextLoginOne = true;
  bool _obscureTextLoginTwo = true;

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  String _email;

  final _signInFormKey = GlobalKey<FormState>();
  String _signInEmail;
  String _signInPassword;

  AuthService _auth = AuthService();

  final _resetPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Material(
        color: Colors.transparent,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(8)),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 22.5,
                  width: SizeConfig.blockSizeHorizontal * 100,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      children: <Widget>[
                        Text("SICKLES", style: GoogleFonts.corben(
                          color: Theme.of(context).accentColor, 
                          fontWeight: FontWeight.bold)),
                        Padding(padding: EdgeInsets.all(0)),
                        Text("FFA", style: GoogleFonts.corben(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  child: Column(
                    children: <Widget> [
                      Stack(
                        alignment: Alignment.topCenter,
                        overflow: Overflow.visible,
                        children: <Widget> [
                          Card(
                            elevation: 10,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Form(
                              key: _signInFormKey,
                              child: Container(
                                width: 300,
                                height: 300,
                                child: Column(
                                  children: <Widget> [
                                    Text("SIGN IN", style: GoogleFonts.corben(color: Theme.of(context).accentColor, fontSize: 45)),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
                                      child: TextFormField(
                                        onSaved: (value) => _signInEmail = value,
                                        focusNode: myFocusNodeEmailLogin,
                                        keyboardType: TextInputType.emailAddress,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(Icons.email, color: Colors.black, size: 22),
                                          hintText: "Email Address",
                                          hintStyle: TextStyle(fontSize: 17)
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10, bottom: 5, left: 25, right: 25),
                                      child: TextFormField(
                                        onSaved: (value) => _signInPassword = value,
                                        focusNode: myFocusNodePasswordLogin,
                                        obscureText: _obscureTextLoginOne,
                                        keyboardType: TextInputType.visiblePassword,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(Icons.lock, color: Colors.black, size: 22),
                                          hintText: "Password",
                                          hintStyle: TextStyle(fontSize: 17),
                                          suffixIcon: GestureDetector(
                                            onTap: () => _toggleLogin("_obscureTextLoginOne"),
                                            child: Icon(_obscureTextLoginOne ? Icons.visibility : Icons.visibility_off, size: 15, color: Colors.black,),
                                          )
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            if(Platform.isIOS) {
                                              return CupertinoAlertDialog(
                                                title: Text("Reset Password"),
                                                content: TextFormField(
                                                  onSaved: (value) => _email = value,
                                                  onChanged: (value) => _email = value,
                                                  decoration: InputDecoration(hintText: "Enter email...")
                                                ),
                                                actions: <Widget>[
                                                  CupertinoButton(
                                                    child: Text("CANCEL"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }
                                                  ),
                                                  CupertinoButton(
                                                    child: Text("CONFIRM"),
                                                    onPressed: () async {
                                                      final resetPassword = _resetPasswordFormKey.currentState;
                                                      resetPassword.save();
                                                      try {
                                                        await AuthService().resetPassword(theEmail: _email);
                                                        Navigator.of(context).pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return CupertinoAlertDialog(
                                                              title: Text("Message"),
                                                              content: Text("Check you email for more information on resetting your password.", textAlign: TextAlign.center,),
                                                              actions: <Widget>[
                                                                CupertinoButton(
                                                                  onPressed: () => Navigator.of(context).pop(), 
                                                                  child: Text("BACK")
                                                                )
                                                              ],
                                                            );
                                                          }
                                                        );
                                                      }
                                                      catch (e) {
                                                        Navigator.of(context).pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return CupertinoAlertDialog(
                                                              title: Text("Error Message"),
                                                              content: Text("The email you entered is not a valid account!", textAlign: TextAlign.center,),
                                                              actions: <Widget>[
                                                                CupertinoButton(
                                                                  onPressed: () => Navigator.of(context).pop(), 
                                                                  child: Text("BACK")
                                                                )
                                                              ],
                                                            );
                                                          }
                                                        );
                                                      }
                                                    }
                                                  ),
                                                ],
                                              );
                                            }
                                            else {
                                              return AlertDialog(
                                                title: Text("Reset Password"),
                                                content: Form(
                                                  key: _resetPasswordFormKey,
                                                  child: TextFormField(
                                                    onSaved: (value) => _email = value,
                                                    onChanged: (value) => _email = value,
                                                    decoration: InputDecoration(hintText: "Enter email...")
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text("CANCEL"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }
                                                  ),
                                                  FlatButton(
                                                    child: Text("CONFIRM"),
                                                    onPressed: () async {
                                                      final resetPassword = _resetPasswordFormKey.currentState;
                                                      resetPassword.save();
                                                      try {
                                                        await AuthService().resetPassword(theEmail: _email);
                                                        Navigator.of(context).pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Message"),
                                                              content: Text("Check you email for more information on resetting your password.", textAlign: TextAlign.center,),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  onPressed: () => Navigator.of(context).pop(), 
                                                                  child: Text("BACK")
                                                                )
                                                              ],
                                                            );
                                                          }
                                                        );
                                                      }
                                                      catch (e) {
                                                        Navigator.of(context).pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Error Message"),
                                                              content: Text("The email you entered is not a valid account!", textAlign: TextAlign.center,),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  onPressed: () => Navigator.of(context).pop(), 
                                                                  child: Text("BACK")
                                                                )
                                                              ],
                                                            );
                                                          }
                                                        );
                                                      }
                                                    }
                                                  ),
                                                ],
                                              );
                                            }
                                          }
                                        );
                                      },
                                      child: Text(
                                        "Forgot Password",
                                        style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 15),
                                      ),
                                    )
                                  ]
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 280.0),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              color: Theme.of(context).accentColor
                            ),
                            child: MaterialButton(
                                highlightColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 42.0),
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,),
                                  ),
                                ),
                                onPressed: () async {
                                  showInSnackBar("Logining In...");
                                  final signInForm = _signInFormKey.currentState;
                                  signInForm.save();
                                  if(signInForm.validate()) {
                                    try {
                                      dynamic result = await _auth.loginUser(
                                        email: _signInEmail,
                                        password: _signInPassword
                                      );
                                    }
                                    catch (e) {
                                      print(e.toString());
                                    }
                                  }
                                }
                            ),
                          ),
                        ],
                      ),
                        ]
                      ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, SizeConfig.blockSizeVertical * 1),
                  child: Text("Developed by: Dylan Bono", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleLogin(String boolean) {
    setState(() {
      if(boolean == "_obscureTextLoginTwo") {
        _obscureTextLoginTwo = !_obscureTextLoginTwo;
      }
      if(boolean == "_obscureTextLoginOne") {
        _obscureTextLoginOne = !_obscureTextLoginOne;
      }
    });
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(seconds: 1),
    ));
  }
}

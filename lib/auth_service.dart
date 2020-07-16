import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ffa_app/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future logout() async {
    try {
      return await _auth.signOut();
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future loginUser({String email, String password, BuildContext context}) async{
    try {
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      var a = await Firestore.instance.collection('members').document(user.uid).get();
      if(a.exists) {
        
      }
      else {
        String firstName;
        String lastName;
        String studentNum;
        String grade;
        String permissions;
        var firestore = FirebaseDatabase.instance.reference().child('members');
        var result = await firestore.child(user.uid).once().then((DataSnapshot snapshot) => {
          firstName = snapshot.value['firstName'],
          lastName = snapshot.value['lastName'],
          grade = snapshot.value['grade'].toString(),
          permissions = snapshot.value['permissions'].toString(),
          studentNum = snapshot.value['studentNum'].toString()
        });
        await DatabaseService(uid: user.uid).updateUserData(firstName, lastName, studentNum, grade, user.uid, permissions);
      }
      return user;
    }
    catch (e) {
      return ErrorMessage(e.message.toString(), context);
    }
  }

  Future<void> ErrorMessage(String body, BuildContext context) async {
    if(Platform.isAndroid) {
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error Message"),
              content: Text(body),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
    }
    else {
      return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Error Message"),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok")
              )
            ],
          );
        }
      );
    }
  }

  Future deleteUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();
  }

  Future resetPassword({String theEmail}) async {
    if(theEmail == null) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String email = user.email;
      var result = await _auth.sendPasswordResetEmail(email: email);
    }
    else {
      var result = await _auth.sendPasswordResetEmail(email: theEmail);
    }
    
  }

  Future createUser({String email, String password}) async {
    var r = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }
}
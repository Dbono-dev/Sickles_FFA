import 'package:ffa_app/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffa_app/main_page.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/sign_in_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return LoginPage();
    }
    else {
      return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          if(snapshot.hasData) {
            return MainPage();
          }
          else {
            return Material(
              color: Colors.white,
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );
    }
  }
}
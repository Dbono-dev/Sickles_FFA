import 'package:ffa_app/database.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:ffa_app/auth_service.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
       color: Colors.white,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget> [
           ReturnButton(),
           Padding(padding: EdgeInsets.all(5)),
           settingsTiles("Change Password", context, changePassword(context)),
           settingsTiles("Report Bug", context, reportBug(context))
         ]
       ),
    );
  }

  Widget settingsTiles(String title, BuildContext context, Widget theWidget) {
    return Card(
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.all(12.5),
      elevation: 10,
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return theWidget;
            }
          );
        },
        title: Text(title, style: TextStyle(color: Theme.of(context).accentColor),),
        trailing: Icon(Icons.arrow_forward, color: Theme.of(context).accentColor,),
      ),
    );
  }

  Widget changePassword(BuildContext context) {
    if(Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text("Change Password"),
        content: Text("Are you sure you would like to reset your password?"),
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CANCEL"),
          ),
          CupertinoButton(
            onPressed: () async {
              await AuthService().resetPassword();
              Navigator.of(context).pop();
            },
            child: Text("CONFIRM"),
          )
        ],
      );
    }
    else {
      return AlertDialog(
        title: Text("Change Password"),
        content: Text("Are you sure you would like to reset your password?"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CANCEL"),
          ),
          FlatButton(
            onPressed: () async {
              await AuthService().resetPassword();
              Navigator.of(context).pop();
            },
            child: Text("CONFIRM"),
          )
        ],
      );
    }
  }

  Widget reportBug(BuildContext context) {
    String _bug;
    final _bugForm = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Report Bug"),
      content: Form(
        key: _bugForm,
        child: TextFormField(
          minLines: 6,
          maxLines: 8,
          onSaved: (val) => _bug = val,
          validator: (value) => value.isEmpty ? 'Enter your reported bug' : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("CANCEL")
        ),
        FlatButton(
          onPressed: () async {
            final result = _bugForm.currentState;
            result.save();
            if(result.validate()) {
              await BugService().reportBug(_bug);
            }
            Navigator.of(context).pop();
          },
          child: Text("SUBMIT")
        )
      ],
    );
  }
}
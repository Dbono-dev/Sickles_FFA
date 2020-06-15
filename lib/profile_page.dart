import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Padding(padding: EdgeInsets.all(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("First Name", style: TextStyle(fontSize: 35, color: Theme.of(context).accentColor),),
                  Text("Last Name", style: TextStyle(fontSize: 35, color: Theme.of(context).accentColor),),
                  Text("Grade", style: TextStyle(fontSize: 35, color: Theme.of(context).accentColor),)
                ],
              ),
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text("FL", style: TextStyle(fontSize: 60, color: Theme.of(context).accentColor),),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Text("Recent", style: TextStyle(fontSize: 45, color: Theme.of(context).accentColor, decoration: TextDecoration.underline),),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Container(
              height: 65,
              width: 375,
              child: Card(
                color: Theme.of(context).primaryColor,
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              )
            ),
          )
        ]
      ),
    );
  }
}
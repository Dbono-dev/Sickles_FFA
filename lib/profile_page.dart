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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
                  child: Row(
                    children: <Widget>[
                      Text("Club Meeting", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30),),
                      Spacer(),
                      Text("7/11",style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30))
                    ],
                  ),
                ),
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Container(
              height: 65,
              width: 375,
              child: Card(
                color: Theme.of(context).primaryColor,
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
                  child: Row(
                    children: <Widget>[
                      Text("Barbeque", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30),),
                      Spacer(),
                      Text("10/21",style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30))
                    ],
                  ),
                ),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Text("More Actions", style: TextStyle(fontSize: 45, color: Theme.of(context).accentColor, decoration: TextDecoration.underline),),
          ),
          Container(
            height: 179,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                moreActionsTiles(Icons.message, "Send Message", context),
                moreActionsTiles(Icons.image, "Send Images", context),
                moreActionsTiles(Icons.settings, "Settings", context)
              ],
            ),
          )
        ]
      ),
    );
  }

  Widget moreActionsTiles(IconData icon, String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
      child: Container(
        height: 65,
        width: 375,
        child: Card(
          color: Theme.of(context).primaryColor,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(icon, color: Theme.of(context).accentColor, size: 40,),
                Text(title,style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35))
              ],
            ),
          ),
        )
      ),
    );
  }
}
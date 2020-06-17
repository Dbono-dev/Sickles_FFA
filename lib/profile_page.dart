import 'package:ffa_app/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/admin_pages/add_event.dart';
import 'package:ffa_app/admin_pages/add_post.dart';
import 'package:ffa_app/admin_pages/export_data.dart';
import 'package:ffa_app/admin_pages/scanning_page.dart';
import 'package:ffa_app/admin_pages/view_attendence.dart';
import 'package:ffa_app/admin_pages/view_images.dart';
import 'package:ffa_app/admin_pages/view_messages.dart';
import 'package:ffa_app/member_pages/send_images.dart';
import 'package:ffa_app/member_pages/send_message.dart';
import 'package:ffa_app/settings.dart';

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
          officerProfilePage(context)
        ]
      ),
    );
  }

  Widget moreActionsTiles(IconData icon, String title, BuildContext context, Widget location) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => location));
        },
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
      ),
    );
  }

  Widget studentProfilePage(BuildContext context) {

    AuthService _auth = new AuthService();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("More Actions", style: TextStyle(fontSize: 45, color: Theme.of(context).accentColor, decoration: TextDecoration.underline),),
                RaisedButton(
                  elevation: 10,
                  child: Text("Logout", style: TextStyle(color: Theme.of(context).accentColor),), 
                  onPressed: () {
                    _auth.logout();
                  },
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
          Container(
            height: 179,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                moreActionsTiles(Icons.message, "Send Message", context, SendMessages()),
                moreActionsTiles(Icons.image, "Send Images", context, SendImages()),
                moreActionsTiles(Icons.settings, "Settings", context, Settings())
              ],
            ),
          )
      ]
    );
  }

  Widget officerProfilePage(BuildContext context) {

    AuthService _auth = new AuthService();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("More Actions", style: TextStyle(fontSize: 45, color: Theme.of(context).accentColor, decoration: TextDecoration.underline),),
                RaisedButton(
                  elevation: 10,
                  child: Text("Logout", style: TextStyle(color: Theme.of(context).accentColor),), 
                  onPressed: () {
                    _auth.logout();
                  },
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
          Container(
            height: 402,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                moreActionsTiles(Icons.event, "Add Event", context, AddEvent()),
                moreActionsTiles(Icons.message, "Add Post", context, AddPost()),
                moreActionsTiles(Icons.people, "View Attendence", context, ViewAttendence()),
                moreActionsTiles(Icons.camera_alt, "Start Scanning", context, ScanningPage()),
                moreActionsTiles(Icons.import_export, "Export Data", context, ExportData()),
                moreActionsTiles(Icons.image, "View Images", context, ViewImages()),
                moreActionsTiles(Icons.message, "View Messages", context, ViewMessages()),
                moreActionsTiles(Icons.settings, "Seetings", context, Settings())
              ],
            ),
          )
      ],
    );
  }
}
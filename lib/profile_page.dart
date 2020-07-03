import 'package:ffa_app/admin_pages/view_minutes.dart';
import 'package:ffa_app/auth_service.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/size_config.dart';
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
import 'package:ffa_app/user.dart';
import 'package:provider/provider.dart';
import 'package:ffa_app/styles.dart';

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Container(
      color: Colors.white,
      child: StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          if(snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Padding(padding: EdgeInsets.all(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(userData.firstName, style: topOfProfilePage),
                        Text(userData.lastName, style: topOfProfilePage),
                        Text(userData.grade.toString() + "th Grade", style: topOfProfilePage)
                      ],
                    ),
                    Card(
                      color: Colors.transparent,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(userData.firstName.toString().substring(0, 1) + userData.lastName.toString().substring(0, 1), style: TextStyle(fontSize: 60, color: Theme.of(context).accentColor),),
                      ),
                    )
                  ],
                ),
                userData.permissions == 1 || userData.permissions == 2 ? officerProfilePage(context) : studentProfilePage(context, userData)
              ]
            );
          }
          else {
            return CircularProgressIndicator();
          }
        }
      ),
    );
  }

  Widget moreActionsTiles(IconData icon, String title, BuildContext context, Widget location) {
    return Padding(
      padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 3, 10, SizeConfig.blockSizeHorizontal * 3, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => location));
        },
        child: Container(
          height: SizeConfig.blockSizeVertical * 10,
          width: SizeConfig.blockSizeHorizontal * 80,
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

  Widget studentProfilePage(BuildContext context, UserData userData) {

    AuthService _auth = new AuthService();
    List eventTitle = new List();
    List eventDate = new List();
    eventTitle = userData.eventTitle;
    eventDate = userData.eventDate;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        userData.permissions == 3 ? Container() : Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Text("Recent", style: TextStyle(fontSize: 45, color: Theme.of(context).accentColor, decoration: TextDecoration.underline),),
          ),
          userData.permissions == 3 ? Container() : SizedBox(
            height: SizeConfig.blockSizeVertical * 15,
            child: eventTitle.length == 0 ? Center(child: Text("No Recent Events", style: TextStyle(fontSize: 25, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),)) : ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: eventTitle.length,
              itemBuilder: (_, index) {
                return studentRecentTiles(context, eventTitle[index], eventDate[index].toString().substring(0, 5));
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 65,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "More Actions", 
                      style: TextStyle(
                        fontSize: 45, 
                        color: Theme.of(context).accentColor,
                         decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 25,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: RaisedButton(
                      elevation: 10,
                      child: Text("Logout", style: TextStyle(color: Theme.of(context).accentColor),), 
                      onPressed: () {
                        _auth.logout();
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: userData.permissions == 3 ? SizeConfig.blockSizeVertical * 53 : SizeConfig.blockSizeVertical * 27,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                moreActionsTiles(Icons.message, "Send Message", context, SendMessages()),
                moreActionsTiles(Icons.image, "Send Images", context, SendImages(name: userData.firstName + " " + userData.lastName)),
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
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 65,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "More Actions", 
                      style: TextStyle(
                        fontSize: 45, 
                        color: Theme.of(context).accentColor,
                         decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 25,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: RaisedButton(
                      elevation: 10,
                      child: Text("Logout", style: TextStyle(color: Theme.of(context).accentColor),), 
                      onPressed: () {
                        _auth.logout();
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: SizeConfig.blockSizeVertical * 53,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                moreActionsTiles(Icons.event, "Add Event", context, AddEvent()),
                moreActionsTiles(Icons.message, "Add Post", context, AddPost()),
                moreActionsTiles(Icons.people, "View Attendence", context, ViewAttendence()),
                moreActionsTiles(Icons.camera_alt, "Start Scanning", context, ScanningPage()),
                moreActionsTiles(Icons.import_export, "Export Data", context, ExportData()),
                moreActionsTiles(Icons.assignment, "View Minutes", context, ViewMinutes()),
                moreActionsTiles(Icons.image, "View Images", context, ViewImages()),
                moreActionsTiles(Icons.message, "View Messages", context, ViewMessages()),
                moreActionsTiles(Icons.settings, "Settings", context, Settings())
              ],
            ),
          )
      ],
    );
  }

  Widget studentRecentTiles(BuildContext context, String title, String date) {
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
              children: <Widget>[
                Text(title, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30),),
                Spacer(),
                Text(date,style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30))
              ],
            ),
          ),
        )
      ),
    );
  }
}
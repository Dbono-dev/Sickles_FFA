import 'package:ffa_app/admin_pages/scanning_options_page.dart';
import 'package:ffa_app/admin_pages/set_important_dates.dart';
import 'package:ffa_app/admin_pages/view_minutes.dart';
import 'package:ffa_app/auth_service.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/admin_pages/add_event.dart';
import 'package:ffa_app/admin_pages/add_post.dart';
import 'package:ffa_app/admin_pages/export_data.dart';
import 'package:ffa_app/admin_pages/view_attendence.dart';
import 'package:ffa_app/admin_pages/view_images.dart';
import 'package:ffa_app/admin_pages/view_messages.dart';
import 'package:ffa_app/member_pages/send_images.dart';
import 'package:ffa_app/member_pages/send_message.dart';
import 'package:ffa_app/settings.dart';
import 'package:ffa_app/user.dart';
import 'package:google_fonts/google_fonts.dart';
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
                        int.tryParse(userData.grade) == null ? Text(userData.grade, style: topOfProfilePage.copyWith(fontWeight: FontWeight.w400)) : Text(userData.grade.toString() + "th Grade", style: topOfProfilePage)
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
                userData.permissions == 1 || userData.permissions == 2 ? officerProfilePage(context, userData) : studentProfilePage(context, userData)
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
                  Text(title, style: GoogleFonts.balooTamma(color: Theme.of(context).accentColor, fontSize: 35))
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
            height: SizeConfig.blockSizeVertical * 17,
            child: eventTitle.length == 0 ? Center(child: Text("No Recent Events", style: TextStyle(fontSize: 25, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),)) : ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: eventTitle.length,
              itemBuilder: (_, index) {
                return studentRecentTiles(context, eventTitle[index], eventDate[index].toString().substring(0, 7));
              }
            ),
          ),
          moreActionsLogout(context, _auth),
          Container(
            height: userData.permissions == 3 ? SizeConfig.blockSizeVertical * 53 : SizeConfig.blockSizeVertical * 26,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                moreActionsTiles(Icons.message, "Send Message", context, SendMessages(type: "student", uid: userData.uid,)),
                moreActionsTiles(Icons.image, "Send Images", context, SendImages(name: userData.firstName + " " + userData.lastName)),
                moreActionsTiles(Icons.settings, "Settings", context, Settings()),
              ],
            ),
          )
      ]
    );
  }

  Widget officerProfilePage(BuildContext context, UserData userData) {

    AuthService _auth = new AuthService();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
          moreActionsLogout(context, _auth),
          Container(
            height: SizeConfig.blockSizeVertical * 54,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                userData.permissions == 2 ? moreActionsTiles(Icons.event, "Add Event", context, AddEvent(type: "new")) : Container(),
                userData.permissions == 2 ? moreActionsTiles(Icons.message, "Add Post", context, AddPost()) : Container(),
                moreActionsTiles(Icons.people, "View Attendance", context, ViewAttendence()),
                moreActionsTiles(Icons.camera_alt, "Start Scanning", context, ScanningOptionsPage()),
                moreActionsTiles(Icons.import_export, "Export Data", context, ExportData()),
                moreActionsTiles(Icons.assignment, "View Minutes", context, ViewMinutes()),
                moreActionsTiles(Icons.image, "View Images", context, ViewImages()),
                moreActionsTiles(Icons.message, "View Messages", context, ViewMessages()),
                userData.permissions == 2 ? moreActionsTiles(Icons.calendar_today, "Set Club Dates", context, ImportantDates()) : Container(),
                moreActionsTiles(Icons.settings, "Settings", context, Settings())
              ],
            ),
          )
      ],
    );
  }

  Widget studentRecentTiles(BuildContext context, String title, String date) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
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
                Text(date,style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20))
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget moreActionsLogout(BuildContext context, AuthService _auth) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, SizeConfig.blockSizeVertical * 2, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: SizeConfig.safeBlockHorizontal * 65,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "More Actions", 
                style: GoogleFonts.ubuntu(
                  fontSize: 45, 
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).accentColor,
                    decoration: TextDecoration.underline
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.blockSizeHorizontal * 25,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
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
    );
  }
}
import 'package:ffa_app/admin_pages/scanning_page.dart';
import 'package:ffa_app/admin_pages/view_saved_scanning_sessions.dart';
import 'package:ffa_app/main.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/size_config.dart';

class ScanningOptionsPage extends StatelessWidget {
  ScanningOptionsPage({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          ReturnButton(),
          Padding(padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 2)),
          theTiles("Create New Scanning Session", ScanningPage(), context),
          theTiles("View Saved Scanning Sessions", ViewSavedScanningSessions(), context),
        ]
      ),
    );
  }

  Widget theTiles(String text, Widget location, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => location));
        },
        child: Card(
          elevation: 10,
          child: ListTile(
            title: Text(text),
            trailing: Icon(Icons.arrow_forward)
          )
        ),
      ),
    );
  }
}
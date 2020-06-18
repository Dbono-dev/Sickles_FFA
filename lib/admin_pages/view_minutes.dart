import 'dart:io';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class ViewMinutes extends StatefulWidget {

  @override
  _ViewMinutesState createState() => _ViewMinutesState();
}

class _ViewMinutesState extends State<ViewMinutes> {
  StorageReference firebaseStorageRef;
  File theFile;
  String theFilePath = "";

  Future<File> getImage() async {
    theFile = await FilePicker.getFile();
  }

  DateTime _newDateTime;
  DateTime startDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {

    String startingDate;
    startingDate = _newDateTime == null ? "Date" : _newDateTime.month.toString() + "/" + _newDateTime.day.toString() + "/" + _newDateTime.year.toString();

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ReturnButton(),
              Padding(padding: EdgeInsets.fromLTRB(150, 0, 0, 0)),
              Container(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: RaisedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Upload Document"),
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                height: SizeConfig.blockSizeVertical * 35,
                                child: Column(
                                  children: <Widget>[
                                    Text("Enter Date of Officer Meeting: "),
                                    OutlineButton(
                                      hoverColor: Theme.of(context).primaryColor,
                                      highlightColor: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                                      borderSide: BorderSide(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 3),
                                      child: Text(startingDate),
                                      onPressed: () async {
                                        _newDateTime = await showRoundedDatePicker(
                                          context: context,
                                          initialDate: startDate,
                                          lastDate: DateTime(DateTime.now().year + 1),
                                          borderRadius: 16,
                                          theme: ThemeData(primarySwatch: Colors.blue),
                                        );
                                        setState(() {
                                          startingDate = _newDateTime.month.toString() + "-" + _newDateTime.day.toString() + "-" + _newDateTime.year.toString();
                                        });
                                      },
                                    ),
                                    OutlineButton(
                                      hoverColor: Theme.of(context).primaryColor,
                                      highlightColor: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                                      borderSide: BorderSide(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 3),
                                      child: Text("Select Document"),
                                      onPressed: () async {
                                        File theFile = await getImage();
                                        setState(() {
                                          theFilePath = theFile.path;
                                        });
                                      },
                                    ),
                                    Text(theFilePath)
                                  ],
                                ),
                              );
                            }
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("CANCEL")
                            ),
                            FlatButton(
                              onPressed: () {
                                firebaseStorageRef = FirebaseStorage.instance.ref().child(startingDate + '.pdf');
                                final StorageUploadTask task = firebaseStorageRef.putFile(theFile);
                              },
                              child: Text("SUBMIT")
                            )
                          ],
                        );
                      }
                    );
                  },
                  elevation: 10,
                  color: Theme.of(context).primaryColor,
                  child: Text("Upload Document", style: TextStyle(color: Theme.of(context).accentColor),),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}
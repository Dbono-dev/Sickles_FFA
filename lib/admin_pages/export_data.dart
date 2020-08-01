import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

enum ExportDataOptions {specificEvent, specificClass, specificPerson, allStudents}

class ExportData extends StatefulWidget {
  @override
  _ExportDataState createState() => _ExportDataState();
}

class _ExportDataState extends State<ExportData> {
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("members").getDocuments();
    return qn.documents;
  }

  Future getEvents() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("events").getDocuments();
    return qn.documents;
  }

  String firstName;
  String lastName;
  String grade;
  String emailAddress;
  String permissions;
  String studentNum;

  ExportDataOptions _choice;
  int x = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: SizeConfig.blockSizeVertical * 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          ReturnButton(),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20)),
          Card(
            elevation: 10,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: RadioListTile<ExportDataOptions>(
              title: Text("Specific Event"),
              value: ExportDataOptions.specificEvent,
              groupValue: _choice,
              onChanged: (ExportDataOptions value) {
                setState(() {
                  _choice = value;
                });
              }
            ),
          ),
          Card(
            elevation: 10,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: RadioListTile<ExportDataOptions>(
              title: Text("Specific Grade Level"),
              value: ExportDataOptions.specificClass,
              groupValue: _choice,
              onChanged: (ExportDataOptions value) {
                setState(() {
                  _choice = value;
                });
              }
            ),
          ),
          Card(
            elevation: 10,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: RadioListTile<ExportDataOptions>(
              title: Text("Specific Person"),
              value: ExportDataOptions.specificPerson,
              groupValue: _choice,
              onChanged: (ExportDataOptions value) {
                setState(() {
                  _choice = value;
                });
              }
            ),
          ),
          Card(
            elevation: 10,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: RadioListTile<ExportDataOptions>(
              title: Text("All Students"),
              value: ExportDataOptions.allStudents,
              groupValue: _choice,
              onChanged: (ExportDataOptions value) {
                setState(() {
                  _choice = value;
                });
              }
            ),
          ),
          Spacer(),
          Material(
            type: MaterialType.transparency,
            child: Container(
            height: SizeConfig.blockSizeVertical * 7,
            width: SizeConfig.blockSizeHorizontal * 100,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.black,
                blurRadius: 15.0,
                spreadRadius: 2.0,
                offset: Offset(0, 10.0)
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              ),
              color: Theme.of(context).primaryColor,
            ),
            child: Builder(
              builder: (context) {
                return FlatButton(
                  child: Text("Export Data", style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor
                  )),
                  onPressed: () async {
                    x = 0;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return exportDataDialog(_choice);
                      }
                    );
                  }
                );
              },
            ),
          ),
          )
        ]
      ),
    );
  }

    Widget exportDataDialog(ExportDataOptions choice) {
    if(choice == ExportDataOptions.allStudents) {
      return AlertDialog(
        title: Text("Confirmation!"),
        content: Text("Are you sure you would like to export all students data?"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel")
          ),
          FlatButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    content: Container(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 27.5),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              );
              QuerySnapshot qn = await Firestore.instance.collection('members').getDocuments();
              var result = qn.documents;
              for(int i = 0; i < result.length; i++) {
                DocumentSnapshot theResult = result[i];
                await _submitForm(theResult, numOfTimes: result.length);
              }
            },
            child: Text("Confirm")
          )
        ],
      );
    }
    else if (choice == ExportDataOptions.specificEvent) {
      return Container(
        height: SizeConfig.blockSizeVertical * 45,
        child: AlertDialog(
          title: Text("Please Choose One!"),
          content: Container(
            child: FutureBuilder(
              future: getEvents(),
              builder: (_, snapshot) {
                if(snapshot.hasData) {
                  List<Widget> theEvents = new List<Widget> ();
                  for(int i = 0; i < snapshot.data.length; i++) {
                    theEvents.add(
                      GestureDetector(
                        onTap: () async {
                          await _submitEventForm(snapshot.data[i]);
                        },
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            title: Text(snapshot.data[i].data['title']),
                          ),
                        ),
                      )
                    );
                  }
                  return Container(
                    height: SizeConfig.blockSizeVertical * 45,
                    width: SizeConfig.blockSizeHorizontal * 75,
                    child: ListView(
                      children: theEvents,
                    ),
                  );
                }
                else {
                  return CircularProgressIndicator(
                    value: SizeConfig.blockSizeVertical * 45,
                  );
                }
              }
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Back")
            )
          ],
        ),
      );
    }
    else if (choice == ExportDataOptions.specificClass) {
      return Container(
        height: SizeConfig.blockSizeVertical * 45,
        child: AlertDialog(
          title: Text("Please Choose One!"),
          content: Container(
            child: FutureBuilder(
              future: getPosts(),
              builder: (_, snapshot) {
                if(snapshot.hasData) {
                  List<Widget> theGrades = new List<Widget> ();
                  for(int i = 9; i < 13; i++) {
                    theGrades.add(
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                content: Container(
                                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 27.5),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          );
                          int numOfTimes = 0;
                          for(int a = 0; a < snapshot.data.length; a++) {
                            if(int.tryParse(snapshot.data[a].data['grade']) == i) {
                              numOfTimes++;
                            }
                          }
                          for(int a = 0; a < snapshot.data.length; a++) {
                            if(int.tryParse(snapshot.data[a].data['grade']) == i) {
                              await _submitForm(snapshot.data[a], numOfTimes: numOfTimes);
                            }
                          }
                        },
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            title: Text("Grade: $i")
                          ),
                        ),
                      )
                    );
                  }
            
                  return Container(
                    height: SizeConfig.blockSizeVertical * 45,
                    width: SizeConfig.blockSizeHorizontal * 75,
                    child: ListView(
                      children: theGrades,
                    ),
                  );
                }
                else {
                  return CircularProgressIndicator(
                    value: SizeConfig.blockSizeVertical * 45,
                  );
                }
              }
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Back")
            )
          ],
        ),
      );
    }
    else if (choice == ExportDataOptions.specificPerson) {
      return Container(
        height: SizeConfig.blockSizeVertical * 45,
        child: AlertDialog(
          title: Text("Please Choose One!"),
          content: Container(
            child: FutureBuilder(
              future: getPosts(),
              builder: (_, snapshot) {
                if(snapshot.hasData) {
                  List<Widget> theEvents = new List<Widget> ();
                  for(int i = 0; i < snapshot.data.length; i++) {
                    theEvents.add(
                      GestureDetector(
                        onTap: () async {
                          await _submitForm(snapshot.data[i], numOfTimes: 1);
                        },
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            title: Text(snapshot.data[i].data['first name'] + " " + snapshot.data[i].data["last name"]),
                          ),
                        ),
                      )
                    );
                  }
                  return Container(
                    height: SizeConfig.blockSizeVertical * 45,
                    width: SizeConfig.blockSizeHorizontal * 75,
                    child: ListView(
                      children: theEvents,
                    ),
                  );
                }
                else {
                  return CircularProgressIndicator(
                    value: SizeConfig.blockSizeVertical * 45,
                  );
                }
              }
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Back")
            )
          ],
        ),
      );
    }
    else {
      return AlertDialog(
        title: Text("Error"),
        content: Text("Please Select an Option"),
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
  }

  Future _submitForm(DocumentSnapshot snapshot, {int numOfTimes}) async {
    FeedbackForm feedbackForm = FeedbackForm(
      snapshot.data['last name'].toString(),
      snapshot.data['first name'].toString(),
      snapshot.data['grade'].toString(),
      snapshot.data['student num'].toString(),
      snapshot.data['event title'],
      snapshot.data['club attendence'],
    );

    ExportPersonFormController formController = ExportPersonFormController((String response) {
      print("Response: $response");
      if(response == FormController.STATUS_SUCCESS) {
        x++;
        if(x == numOfTimes) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      }
    });

    await formController.submitForm(feedbackForm);
  }

  Future _submitEventForm(DocumentSnapshot snapshot) async {
    EventForm theEventForm = EventForm(
      snapshot.data['title'].toString(),
      snapshot.data['date'].toString().substring(0, 10),
      snapshot.data['start time'].toString(),
      snapshot.data['end time'].toString(),
      snapshot.data['type'].toString(),
      snapshot.data['participates name'],
      snapshot.data['participates info']
    );


    FormController eventForm = FormController((String response) {
      print("Response: $response");
      if(response == FormController.STATUS_SUCCESS) {
        Navigator.of(context).pop();
      }
    });

    await eventForm.submitEvent(theEventForm);
  }
}


class EventForm {
  final String _title;
  final String _date;
  final String _startTime;
  final String _endTime;
  final String _type;
  var participants;
  var participantsInfo;

  EventForm(this._title, this._date, this._startTime, this._endTime, this._type, this.participants, this.participantsInfo);

  String toParams() => "?title=$_title&date=$_date&startTime=$_startTime&endTime=$_endTime&type=$_type&participants=$participants&participantsInfo=$participantsInfo";
}


class FeedbackForm {
  String _firstName;
  String _lastName;
  String _grade;
  String _studentNum;
  List _eventTitle;
  var _clubAttendence;

  FeedbackForm(this._lastName, this._firstName, this._grade, this._studentNum, this._eventTitle, this._clubAttendence);

  String toParams() => "?lastName=$_lastName&firstName=$_firstName&grade=$_grade&studentNum=$_studentNum&eventTitle=$_eventTitle&clubAttendence=$_clubAttendence";
}

class FormController {
  final void Function(String) callback;
  static const String URL = "https://script.google.com/macros/s/AKfycbw_uUV-p22JHKLWmTnfQYLf_Gxm_tygss1s5rCKY7CuZIkC2FlR/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);

  Future submitEvent(EventForm eventForm) async {
    try {
      await http.get(URL + eventForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    }
    catch (e) {
      print(e);
    }
  }
}

class ExportPersonFormController {
  final void Function(String) callback;
  static const String URL = "https://script.google.com/macros/s/AKfycbxpShdJQlUWhepg9H96Z1JAwgCGi91zRzpZZA48ZmkuYDCntE6X/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  ExportPersonFormController(this.callback);

  Future submitForm(FeedbackForm feedbackForm) async {
    try {
      await http.get(URL + feedbackForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    }
    catch (e) {
      print(e);
    }
  }
}
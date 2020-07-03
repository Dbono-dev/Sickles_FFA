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
            onPressed: () async  {
              QuerySnapshot qn = await Firestore.instance.collection('members').getDocuments();
              var result = qn.documents;
              for(int i = 0; i < result.length; i++) {
                DocumentSnapshot theResult = result[i];
                _submitForm(theResult, numOfTimes: result.length);
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
                        onTap: () {
                          _submitEventForm(snapshot.data[i]);
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
                  for(int i = 10; i < 13; i++) {
                    theGrades.add(
                      GestureDetector(
                        onTap: () async {
                          for(int a = 0; a < snapshot.data.length; a++) {
                            if(int.tryParse(snapshot.data[a].data['grade']) == i) {
                              _submitForm(snapshot.data[a]);
                              await Future.delayed(Duration(seconds: 2));
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
                        onTap: () {
                          _submitForm(snapshot.data[i], numOfTimes: 1);
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
    int x = 0;

    FeedbackForm feedbackForm = FeedbackForm(
      snapshot.data['last name'].toString(),
      snapshot.data['first name'].toString(),
      snapshot.data['grade'].toString(),
      snapshot.data['student number'].toString(),
      snapshot.data['event title'],
      snapshot.data['event date'],
    );

    ExportPersonFormController formController = ExportPersonFormController((String response) {
      print("Response: $response");
      if(response == FormController.STATUS_SUCCESS) {
        x++;
        if(x == numOfTimes) {
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
      snapshot.data['start time'].toString() + ":" + snapshot.data['start time minutes'].toString(),
      snapshot.data['end time'].toString() + ":" + snapshot.data['end time minutes'].toString(),
      snapshot.data['type'].toString()
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
  String _title;
  String _date;
  String _startTime;
  String _endTime;
  String _type;

  EventForm(this._title, this._date, this._startTime, this._endTime, this._type);

  String toParams() => "?title=$_title&date=$_date&startTime=$_startTime&endTime=$_endTime&type=$_type";
}


class FeedbackForm {
  String _firstName;
  String _lastName;
  String _grade;
  String _studentNum;
  List _eventTitle;
  List _eventDate;

  FeedbackForm(this._lastName, this._firstName, this._grade, this._studentNum, this._eventTitle, this._eventDate);

  String toParams() => "?lastName=$_lastName&firstName=$_firstName&grade=$_grade&studentNum=$_studentNum&eventTitle=$_eventTitle&eventDate=$_eventDate";
}

class FormController {
  final void Function(String) callback;
  static const String URL = "https://script.google.com/macros/s/AKfycbyrDN8nw3eEBfIb84Yx-OVuzUj3i3EKfhv-DK3A-_qr015Yb-DR/exec";

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
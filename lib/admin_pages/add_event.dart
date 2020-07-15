import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/main.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:ffa_app/main_page.dart';

class AddEvent extends StatefulWidget {

  AddEvent({this.snapshot, this.type});

  final DocumentSnapshot snapshot;
  String type;

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DateTime newDateTime () {
    int theCurrentTime = DateTime.now().minute;
    DateTime theNewDateTime = DateTime.now();

    while(theCurrentTime % 15 != 0) {
      theCurrentTime += 1;
    }

    DateTime thenewDate = new DateTime(theNewDateTime.year, theNewDateTime.month, theNewDateTime.day, theNewDateTime.hour, theCurrentTime, theNewDateTime.second);
    return thenewDate;
  }

  DateTime startDate = new DateTime.now();
  DateTime _newDateTime;
  String theStartTime;
  String theEndTime;
  String _title;
  String _description;
  int _startTime;
  int _startTimeMinutes;
  int _endTime;
  int _endTimeMinutes;
  String _address;
  String _date;
  String _max;
  bool theSwitch;
  DateTime theInitialStartTime;
  DateTime theInitialEndTime;

  @override
  Widget build(BuildContext context) {
    final _thirdformKey = GlobalKey<FormState>();
    String _bottomText = "Create Event";
    String _snackBarText = "Created Event";
    DocumentSnapshot _snapshot = widget.snapshot;
    DateFormat format = new DateFormat("MM-dd-yyyy");
    DateFormat time = new DateFormat("HH:mm");

    if(widget.type == "edit") {
      _title = _snapshot.data['title'];
      _description = _snapshot.data['description'];
      _date = _snapshot.data['date'];
      _newDateTime = format.parse(_snapshot.data['date']);
      _startTime = int.parse(_snapshot.data['start time'].toString().substring(0, 2));
      if(int.parse(_snapshot.data['start time'].toString().substring(3, 4)) == 0) {
        _startTimeMinutes = 0;
      }
      else {
        _startTimeMinutes = int.parse(_snapshot.data['start time'].toString().substring(3, 5));
      }
      _endTime = int.parse(_snapshot.data['end time'].toString().substring(0, 2));
      if(int.parse(_snapshot.data['end time'].toString().substring(3, 4)) == 0) {
        _endTimeMinutes = 0;
      }
      else {
        _endTimeMinutes = int.parse(_snapshot.data['end time'].toString().substring(3, 5));
      }
      _address = _snapshot.data['location'];
      _max = _snapshot.data['max participates'];
      startDate = format.parse(_snapshot.data['date']);
      theInitialStartTime = time.parse(_snapshot.data['start time']);
      theInitialEndTime = time.parse(_snapshot.data['end time']);
      _bottomText = "Save Event";
      if(_snapshot.data['information dialog'] == true) {
        theSwitch = true;
      }
      _snackBarText = "Saved Event";
    }
    else if(widget.type == "club") {
      _description = _snapshot.data['agenda'];
      _title = "Club Meeting";
      _date = _snapshot.data['date'];
      _newDateTime = DateTime.now();
      theStartTime = "10:56";
      theEndTime = "11:31";
      _address = "Sickles High";
      _bottomText = "Save Club Meeting";
      _snackBarText = "Saving...";
    }
    else {
      theInitialStartTime = newDateTime();
      theInitialEndTime = newDateTime();
    }

    if(theStartTime == null) {
      theStartTime = "Start Time";
    }

    if(theEndTime == null) {
      theEndTime = "End Time";
    }

    if(theSwitch == null) {
      theSwitch = false;
    }

    if(_startTime != null) {
      theStartTime = _startTime.toString() + ":" + _startTimeMinutes.toString();
    }

    if(_endTime != null) {
      theEndTime = _endTime.toString() + ":" + _endTimeMinutes.toString();
    }

    String startingDate;
    startingDate = _newDateTime == null ? "Date" : _newDateTime.month.toString() + "/" + _newDateTime.day.toString() + "/" + _newDateTime.year.toString();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.blockSizeVertical * 100,
          child: Form(
            key: _thirdformKey,
            child: Container(
              color: Colors.transparent,
              height: SizeConfig.blockSizeVertical * 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  ReturnButton(),
                  Padding(padding: EdgeInsets.all(8)),
                  Material(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, 0, SizeConfig.blockSizeHorizontal * 4.8, 0),
                      child: TextFormField(
                        enabled: widget.type == "club" ? false : true,
                        decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Title',
                      ),
                        onChanged: (val) => _title = (val),
                        validator: (val) => val.isEmpty ? 'Enter Title' : null,
                        initialValue: _title,
                      ),
                    )
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 0.9, 0, 0)),
                  Material(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, 0, SizeConfig.blockSizeHorizontal * 4.8, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: widget.type == "club" ? "Agenda" : "Description",
                          border: OutlineInputBorder()
                        ),
                        minLines: 3,
                        maxLines: 4,
                        onChanged: (val) => _description = (val),
                        validator: (val) => val.isEmpty ? 'Enter Description' : null,
                        initialValue: _description,
                      ),
                    )
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0.0, SizeConfig.blockSizeVertical * 0.9, 0.0, 00)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget> [
                      OutlineButton(
                        hoverColor: Theme.of(context).primaryColor,
                        highlightColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 3),
                        child: Text(startingDate),
                        onPressed: () async {
                          if(widget.type != "club") {
                            _newDateTime = await showRoundedDatePicker(
                              context: context,
                              initialDate: startDate,
                              lastDate: DateTime(DateTime.now().year + 1),
                              borderRadius: 16,
                              theme: ThemeData(primarySwatch: Colors.blue),
                            );
                            if(_newDateTime != null) {
                              setState(() {
                                startingDate = _newDateTime.month.toString() + "/" + _newDateTime.day.toString() + "/" + _newDateTime.year.toString();
                              });
                            }
                          }
                        },
                      ),
                      OutlineButton(
                        hoverColor: Theme.of(context).primaryColor,
                        highlightColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 3),
                    child: Text(theStartTime),
                    onPressed: () {
                      if(widget.type != "club") {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                                height: MediaQuery.of(context).copyWith().size.height / 3,
                                child: CupertinoDatePicker(
                                  initialDateTime: theInitialStartTime,
                                  onDateTimeChanged: (DateTime newdate) {
                                    _startTime = newdate.hour;
                                    _startTimeMinutes = newdate.minute;
                                    if(_startTimeMinutes == 0) {
                                      theStartTime = _startTime.toString() + ":" + "00";
                                    }
                                    theStartTime = _startTime.toString() + ":" + _startTimeMinutes.toString();
                                    setState(() {
                                      
                                    });
                                  },
                                  use24hFormat: false,
                                  maximumDate: new DateTime(2030, 12, 30),
                                  minimumYear: 2020,
                                  maximumYear: 2030,
                                  minuteInterval: 15,
                                  mode: CupertinoDatePickerMode.time,
                            ));
                          });
                      }
                    },
                  ),
                      OutlineButton(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 3),
                        child: Text(theEndTime),
                        onPressed: () {
                          if(widget.type != "club") {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                    height: MediaQuery.of(context).copyWith().size.height / 3,
                                    child: CupertinoDatePicker(
                                      initialDateTime: theInitialEndTime,
                                      onDateTimeChanged: (DateTime newdate) {
                                        _endTime = newdate.hour;
                                        _endTimeMinutes = newdate.minute;
                                        theEndTime = _endTime.toString() + ":" + _endTimeMinutes.toString();
                                        setState(() {
                                          
                                        });
                                      },
                                      use24hFormat: false,
                                      maximumDate: new DateTime(2030, 12, 30),
                                      minimumYear: 2020,
                                      maximumYear: 2030,
                                      minuteInterval: 15,
                                      mode: CupertinoDatePickerMode.time,
                                ));
                              });
                          }
                        },
                      ),
                    ]
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0.0, SizeConfig.blockSizeVertical * 0.9, 0.0, 0.0)),
                  Material(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, 0, SizeConfig.blockSizeHorizontal * 4.8, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Address/Location",
                          border: OutlineInputBorder()
                      ),
                        onChanged: (val) => _address = val,
                        enabled: widget.type == "club" ? false : true,
                        validator: (val) => val.isEmpty ? 'Enter Address or Location' : null,
                        initialValue: _address,
                      ),
                    )
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0.0, SizeConfig.blockSizeVertical * 0.9, 0, 0)),
                  Material(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, 0, SizeConfig.blockSizeHorizontal * 4.8, 0),
                      child: TextFormField(
                        onChanged: (val) => _max = val,
                        initialValue: _max,
                        keyboardType: TextInputType.number,
                        enabled: widget.type == "club" ? false : true,
                        validator: (val) => val.isEmpty ? 'Enter Max Number of Participants' : null,
                        decoration: InputDecoration(
                          hintText: "Max Number Of Participants",
                          border: OutlineInputBorder()
                      ),                      
                      ),
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Member Sign Up Input Requirement"),
                      Switch(
                        value: theSwitch,
                        onChanged: (bool change) {
                          setState(() {
                            if(widget.type != "club") {
                              theSwitch = change;
                            }
                          });
                        }
                      ),
                    ],
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
                          child: Text(_bottomText, style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor
                          )),
                          onPressed: () async {
                            print("clicked");
                            final form = _thirdformKey.currentState;
                            form.save();
                            print("got here");
                            if(widget.type == "club") {
                              await DatabaseImporantDates().updateAgenda(widget.snapshot.data['type'], widget.snapshot.data['date'], _description);
                              Navigator.of(context).pop();
                            }
                            else if(form.validate()) {
                              try {
                                try {
                                  _date = _newDateTime.toString().substring(5, 7) + "-" + _newDateTime.toString().substring(8, 10) + "-" + _newDateTime.toString().substring(0, 4);
                                }
                                catch (e) {
                                  await showErrorDialog("Please make sure to add a date to this event");
                                }
                                if(_startTime == null || _startTimeMinutes == null || _endTime == null || _endTimeMinutes == null) {
                                  await showErrorDialog("Please make sure to have both a start time and end time");
                                }
                                else {
                                  String _startTimeString;
                                  String _endTimeString;
                                  if(_startTime < 10) {
                                    _startTimeString = "0" + _startTime.toString();
                                  }
                                  else {
                                    _startTimeString = _startTime.toString();
                                  }
                                  if(_endTime < 10) {
                                    _endTimeString = "0" + _endTime.toString();
                                  }
                                  else {
                                    _endTimeString = _endTime.toString();
                                  }
                                  dynamic result = await sendEventToDatabase(_title, _date,  _description, _address, _startTimeString + ":" + _startTimeMinutes.toString(), _endTimeString + ":" + _endTimeMinutes.toString(), _max, "event", theSwitch, widget.type == "new" ? [] : widget.snapshot.data['participates'], widget.type == "new" ? [] : widget.snapshot.data['participates name'], widget.type == "new" ? [] : widget.snapshot.data['participates info'], widget.type == "edit" ? widget.snapshot.data['key'].toString() : "", widget.type == "edit" ? "save" : "submit");
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_snackBarText, style: TextStyle(color: Theme.of(context).accentColor),),
                                      backgroundColor: Theme.of(context).primaryColor,
                                      elevation: 8,
                                      duration: Duration(seconds: 3),
                                    )
                                  );
                                  if(widget.type == "edit") {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));
                                  }
                                  setState(() {
                                    _thirdformKey.currentState.reset();
                                    _title = "";
                                    _description = "";
                                    _address = "";
                                    _max = "";
                                    theStartTime = null;
                                    theEndTime = null;
                                    _newDateTime = null;
                                    _startTime = null;
                                    _endTime = null;
                                    widget.type = "";
                                  });
                                }
                              }
                              catch (e) {
                                return CircularProgressIndicator();
                              }
                            } 
                            else {
                              return Container();
                            }}
                        );
                      },
                    ),
                  ),
                  )
                ]
              ),
            )
          ),
        ),
      ),
    );
  }

  Future sendEventToDatabase(String title, String date, String description, String location, String startTime, String endTime, String maxParticipates, String type, bool theSwitch, List participates, List participatesName, List participatesInfo, String key, String saveSubmit) async {
    await EventService().addEvent(title, date, description, location, startTime, endTime, maxParticipates, type, theSwitch, participates, participatesName, participatesInfo, key, saveSubmit);
  }

  Future showErrorDialog(String text) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text("DONE")
            )
          ],
        );
      }
    );
  }
}
import 'package:ffa_app/database.dart';
import 'package:ffa_app/main.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class AddEvent extends StatefulWidget {

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
  int selectedValue;
  int secondSelectedValue;
  String typeOfDate = "";
  DateTime onDate;  
  String theDate;
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

  @override
  Widget build(BuildContext context) {
    final _thirdformKey = GlobalKey<FormState>();
    String _bottomText = "Create Event";

    if(theStartTime == null) {
      theStartTime = "Start Time";
    }

    if(theEndTime == null) {
      theEndTime = "End Time";
    }

    if(onDate != null) {
      theDate = " until " + onDate.month.toString() + "/" + onDate.day.toString() + "/" + onDate.year.toString();
    }
    else {
      theDate = "";
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
      body: Form(
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
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Title',
                  ),
                    onChanged: (val) => _title = (val),
                    initialValue: _title,
                  ),
                )
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 0.73, 0, 0)),
              Material(
                child: Container(
                  padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, 0, SizeConfig.blockSizeHorizontal * 4.8, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder()
                    ),
                    minLines: 3,
                    maxLines: 6,
                    onChanged: (val) => _description = (val),
                    initialValue: _description,
                  ),
                )
              ),
              Padding(padding: EdgeInsets.fromLTRB(0.0, SizeConfig.blockSizeVertical * 0.73, 0.0, 00)),
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
                      _newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: startDate,
                        lastDate: DateTime(DateTime.now().year + 1),
                        borderRadius: 16,
                        theme: ThemeData(primarySwatch: Colors.blue),
                      );
                      setState(() {
                        startingDate = _newDateTime.month.toString() + "/" + _newDateTime.day.toString() + "/" + _newDateTime.year.toString();
                      });
                    },
                  ),
                  OutlineButton(
                    hoverColor: Theme.of(context).primaryColor,
                    highlightColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 3),
                child: Text(theStartTime),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext builder) {
                      return Container(
                          height: MediaQuery.of(context).copyWith().size.height / 3,
                          child: CupertinoDatePicker(
                            initialDateTime: newDateTime(),
                            onDateTimeChanged: (DateTime newdate) {
                              _startTime = newdate.hour;
                              _startTimeMinutes = newdate.minute;
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
                },
              ),
                  OutlineButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 3),
                    child: Text(theEndTime),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                              height: MediaQuery.of(context).copyWith().size.height / 3,
                              child: CupertinoDatePicker(
                                initialDateTime: newDateTime(),
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
                    },
                  ),
                ]
              ),
              Padding(padding: EdgeInsets.fromLTRB(0.0, SizeConfig.blockSizeVertical * 0.73, 0.0, 0.0)),
              Material(
                child: Container(
                  padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, 0, SizeConfig.blockSizeHorizontal * 4.8, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Address/Location",
                      border: OutlineInputBorder()
                  ),
                    onChanged: (val) => _address = val,
                    initialValue: _address,
                  ),
                )
              ),
              Padding(padding: EdgeInsets.fromLTRB(0.0, SizeConfig.blockSizeVertical * 0.73, 0, 0)),
              Material(
                child: Container(
                  padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, 0, SizeConfig.blockSizeHorizontal * 4.8, 0),
                  child: TextFormField(
                    onChanged: (val) => _max = val,
                    initialValue: _max,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Max Number Of Participants",
                      border: OutlineInputBorder()
                  ),                      
                  ),
                )
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

                        _date = _newDateTime.toString().substring(5, 7) + "-" + _newDateTime.toString().substring(8, 10) + "-" + _newDateTime.toString().substring(0, 4);
                        
                        if(form.validate()) {
                          try {
                            dynamic result = sendEventToDatabase(_title, _date,  _description, _address, _startTime.toString() + ":" + _startTimeMinutes.toString(), _endTime.toString() + ":" + _endTimeMinutes.toString(), _max, "event");
                            if(result == null) {
                              print("Fill in all the forms.");
                            }
                            if(result != null) {
                              setState(() {
                                _thirdformKey.currentState.reset();
                                _title = "";
                                _description = "";
                                _address = "";
                                _max = "";
                                theStartTime = "Start Time";
                                theEndTime = "End Time";
                                startingDate = "Date";
                              });
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Event Created", style: TextStyle(color: Theme.of(context).accentColor),),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  elevation: 8,
                                  duration: Duration(seconds: 3),
                                )
                              );
                            }
                          }
                          catch (e) {
                            return CircularProgressIndicator();
                          }
                        } 
                        else {
                          print("failed");
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
    );
  }
  Future sendEventToDatabase(String title, String date, String description, String location, String startTime, String endTime, String maxParticipates, String type) async {
    await EventService().addEvent(title, date, description, location, startTime, endTime, maxParticipates, type);
  }
}
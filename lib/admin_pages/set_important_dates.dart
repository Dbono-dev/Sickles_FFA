import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:ffa_app/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ImportantDates extends StatefulWidget {
  @override
  _ImportantDatesState createState() => _ImportantDatesState();
}

class _ImportantDatesState extends State<ImportantDates> {
  String _date;

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("club dates").getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          ReturnButton(),
          Padding(padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.46, horizontal: SizeConfig.blockSizeHorizontal * 2.43)),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text("Set Club Dates", style: TextStyle(fontSize: 25),),
                    Padding(padding: EdgeInsets.all(5)),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 35,
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        elevation: 8,
                        child: FlatButton(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Icon(
                                Icons.add_circle_outline,
                                size: 35,
                                color: Theme.of(context).accentColor,
                              ),
                              Text("Add", style: TextStyle(fontSize: 25, color: Theme.of(context).accentColor),)
                            ]
                          ),
                          onPressed: () {
                            showModalBottomSheet(context: context, isDismissible: false, builder: (BuildContext builder) {
                              return setClubDates("new", "clubDates", "", "", "");
                            });
                          },
                        )
                      ),
                    )
                  ]
                ),
              Container(
                height: SizeConfig.blockSizeVertical * 27.5,
                width: SizeConfig.blockSizeHorizontal * 85,
                child: FutureBuilder(
                  future: getPosts(),
                  builder: (_, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      );
                    }
                  return snapshot.data.length == 0 ? Center(child: Text("NO CLUB DATES", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 30),)) : ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                     if(snapshot.data[index].data['type'].toString() == "clubDates") {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),                        
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snapshot.data[index].data['date'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Theme.of(context).accentColor),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).accentColor,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(context: context, isDismissible: false, builder: (BuildContext builder) {
                                    return setClubDates("edit", "clubDates", snapshot.data[index].data['date'].toString(), "", snapshot.data[index].data['participates']);
                                  });
                                }
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).accentColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    deleteDateToDatabase(snapshot.data[index].data['type'].toString(), snapshot.data[index].data['date'].toString());
                                  });
                                }
                              )
                            ],
                          )
                        ),
                      );
                    }
                    else {
                        return Container();
                      }
                    }
                  );
                  },
                ),
              ),
              ],
            ),
          )
        ]
      ),
    );
  }

  Future sendDateToDatabase(String type, String date) async {
    await DatabaseImporantDates().setImportantDates(type, date, []);
  }

  Future editDateToDatabase(String type, String newDate, String oldDate, var participates) async {
    await DatabaseImporantDates().updateImportantDates(type, oldDate, newDate, participates);
  }

  Future deleteDateToDatabase(String type, String date) async {
    await DatabaseImporantDates().deleteImportantDates(type, date);
  }

  Widget setClubDates(String editOrNew, String type, String oldDate, String quarter, var partipates) {
    return Container(
      height: SizeConfig.blockSizeVertical * 43,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  setState(() {
                    if(type == "clubDates" && editOrNew == "new") {
                      sendDateToDatabase("clubDates", _date);
                    }
                    else {
                      editDateToDatabase("clubDates", oldDate, _date, partipates);
                    }
                    Navigator.of(context).pop();
                  });
                },
                child: Text("DONE", style: TextStyle(color: Theme.of(context).accentColor), textAlign: TextAlign.right,),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("CANCEL", style: TextStyle(color: Theme.of(context).accentColor), textAlign: TextAlign.right,),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) {
                _date = newDate.toString().substring(5, 7) + "-" + newDate.toString().substring(8, 10) + "-" + newDate.toString().substring(0, 4);
              },
              mode: CupertinoDatePickerMode.date,
              maximumDate: new DateTime(2030, 12, 30)
            ),
          ),
        ],
      ),
    );
  }
}
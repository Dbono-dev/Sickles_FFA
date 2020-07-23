import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/main.dart';

class ViewAttendence extends StatefulWidget {

  @override
  _ViewAttendenceState createState() => _ViewAttendenceState();
}

class _ViewAttendenceState extends State<ViewAttendence> {

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("members").getDocuments();
    return qn.documents;
  }

  String search = "";
  bool freshman = false;
  bool firstCheck = false;
  bool secondCheck = false;
  bool thirdCheck = false;

  List<String> checks = new List<String> ();

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          ReturnButton(),
          Padding(padding: EdgeInsets.all(10)),
          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 2.43, 0, SizeConfig.blockSizeHorizontal * 2.43, 0),
              child: TextFormField(
                initialValue: search,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Theme.of(context).accentColor)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor), borderRadius: BorderRadius.circular(30)),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).accentColor,),
                ),
                onChanged: (text) {
                  setState(() {
                    search = text;
                  });
                },
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
          Container(
            color: Colors.transparent,
            child: Card(
              elevation: 8,
              margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 2.43, 0, SizeConfig.blockSizeHorizontal * 2.43, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
              ),
              child: ExpansionTile(
                title: Text("Filter"),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Grade:"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("9th Grade:"),
                          Checkbox(
                            activeColor: Theme.of(context).accentColor,
                            value: freshman,
                            onChanged: (alsonewValue) {
                              if(checks.length == 0 || freshman) {
                                setState(() {
                                  if(freshman) {
                                    checks.remove('freshman');
                                    freshman = alsonewValue;
                                  }
                                  else {
                                    checks.add('freshman');
                                    freshman = alsonewValue;
                                  }
                                });
                              }
                            },
                          ),
                          Text("10th Grade:"),
                          Checkbox(
                            activeColor: Theme.of(context).accentColor,
                            value: firstCheck,
                            onChanged: (newValue) {
                              if(checks.length == 0 || firstCheck) {
                                setState(() {
                                  if(firstCheck) {
                                    checks.remove('first');
                                    firstCheck = newValue;
                                  }
                                  else {
                                    checks.add('first');
                                    firstCheck = newValue;
                                  }
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget> [
                          Text("11th Grade:"),
                          Checkbox(
                            activeColor: Theme.of(context).accentColor,
                            value: secondCheck,
                            onChanged: (theNewValue) {
                              if(checks.length == 0 || secondCheck) {
                                setState(() {
                                  if(secondCheck) {
                                    checks.remove('second');
                                    secondCheck = theNewValue;
                                  }
                                  else {
                                    checks.add('second');
                                    secondCheck = theNewValue;
                                  }
                                });
                              }
                            },  
                          ),
                          Text("12th Grade:"),
                          Checkbox(
                            activeColor: Theme.of(context).accentColor,
                            value: thirdCheck,
                            onChanged: (theNewValue2) {
                              if(checks.length == 0 || thirdCheck) {
                                setState(() {
                                  if(thirdCheck) {
                                    checks.remove('third');
                                    thirdCheck = theNewValue2;
                                  }
                                  else {
                                    checks.add('third');
                                    thirdCheck = theNewValue2;
                                  }
                                });
                              }
                            },
                          )
                        ]
                      ),
                    ],
                  )
                ],
              )
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Expanded(
            child: FutureBuilder(
              future: getPosts(),
              builder: (_, index) {
                if(index.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                }
                else {
                  return Container(
                    height: SizeConfig.blockSizeVertical * 70,
                    width: SizeConfig.blockSizeHorizontal * 100,
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 5, 0, SizeConfig.blockSizeHorizontal * 5, 0),
                      itemCount: index.data.length,
                      itemBuilder: (_, snapshot) {
                        if(search != "") {
                          if(index.data[snapshot].data['first name'].toString().contains(search) || index.data[snapshot].data['last name'].toString().contains(search) || (index.data[snapshot].data["first name"] + " " + index.data[snapshot].data["last name"]).toString().contains(search)) {
                            return studentTiles(index.data[snapshot], context);
                          }
                          else {
                            return Container();
                          }
                        }
                        else if(freshman) {
                          if(int.tryParse(index.data[snapshot].data['grade']) == 9 && index.data[snapshot].data['permissions'] != 1) {
                            return studentTiles(index.data[snapshot], context);
                          }
                          else {
                            return Container();
                          }
                        }
                        else if(firstCheck) {
                          if(int.tryParse(index.data[snapshot].data['grade']) == 10 && index.data[snapshot].data['permissions'] != 1) {
                            return studentTiles(index.data[snapshot], context);
                          }
                          else {
                            return Container();
                          }
                        }
                        else if(secondCheck) {
                          if(int.tryParse(index.data[snapshot].data['grade']) == 11 && index.data[snapshot].data['permissions'] != 1) {
                            return studentTiles(index.data[snapshot], context);
                          }
                          else {
                            return Container();
                          }
                        }
                        else if(thirdCheck) {
                          if(int.tryParse(index.data[snapshot].data['grade']) == 12 && index.data[snapshot].data['permissions'] != 1) {
                            return studentTiles(index.data[snapshot], context);
                          }
                          else {
                            return Container();
                          }
                        }
                        else if(int.tryParse(index.data[snapshot].data['grade']) == null || index.data[snapshot].data['permissions'] == 1) {
                          return Container();
                        }
                        else {
                          return studentTiles(index.data[snapshot], context);
                        }
                      }
                    ),
                  );
                }
              }
            ),
          )
        ]
      ),
    );
  }

  Widget studentTiles(DocumentSnapshot snapshot, BuildContext context) {
    return GestureDetector(
      onTap: () {
        List eventTitle = new List();
        eventTitle = snapshot.data['event title'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: SizeConfig.blockSizeVertical * 60,
              width: SizeConfig.blockSizeHorizontal * 80,
              child: AlertDialog(
                title: Text("Student Information"),
                content: Container(
                  height: SizeConfig.blockSizeVertical * 60,
                  child: Column(
                    children: <Widget>[
                      Text(snapshot.data['first name'] + " " + snapshot.data['last name']),
                      Text("Grade: " + snapshot.data['grade'].toString()),
                      Text("Recent Events", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      Container(
                        height: SizeConfig.blockSizeVertical * 30,
                        width: SizeConfig.blockSizeHorizontal * 80,
                        child: ListView.builder(
                          itemCount: eventTitle.length,
                          itemBuilder: (_, index) {
                            return Card(
                              elevation: 10,
                              child: ListTile(
                                title: Text(eventTitle[index]),
                                trailing: Text(snapshot.data['event date'][index]),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("DONE")
                  )
                ],
              ),
            );
          }
        );
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 11,
        width: SizeConfig.blockSizeHorizontal * 80,
        child: Card(
          color: Theme.of(context).primaryColor,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(snapshot.data['first name'] + " " + snapshot.data['last name'], style: TextStyle(color: Theme.of(context).accentColor),),
                Text("Grade: " + snapshot.data['grade'].toString(), style: TextStyle(color: Theme.of(context).accentColor),)
              ],
            ),
            trailing: Icon(Icons.arrow_forward, size: 40, color: Theme.of(context).accentColor,),
          )
        ),
      ),
    );
  }
}
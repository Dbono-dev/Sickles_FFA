import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/admin_pages/add_event.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/events.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ffa_app/user.dart';

class EventViewPage extends StatefulWidget {

  EventViewPage({this.event, this.userData});

  final Events event;
  final UserData userData;

  @override
  _EventViewPageState createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  int x = 0;
  String bottomOfCard = "Tap to show QR Code";
  bool show = true;
  String signUp = "SIGN UP";

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    String theQrContent;
    String title;
    String description;
    Events event = widget.event;

    if(event.type != "clubDates") {
      if(event.participates.length == int.parse(event.maxParticipates)) {
        signUp = "EVENT FULL";
      }

      if(event.participates.contains(user.uid)) {
        signUp = "SIGNED UP";
      }
      theQrContent = event.title + "/" + widget.userData.uid + "/" + widget.userData.firstName + " " + widget.userData.lastName;
      title = event.title;
      description = event.description;
    }
    else {
      theQrContent = event.date + "/" + widget.userData.uid + "/" + widget.userData.firstName + " " + widget.userData.lastName;
      title = "Club Meeting";
      description = event.agenda;
    }

    String qrContent = "";
    String _info;

    List<int> theListOfInts = new List<int> ();

    for(int i = 0; i < theQrContent.length; i++) {
      var char = theQrContent[i];
      int temp = char.codeUnitAt(0) + 5;
      theListOfInts.add(temp);
      String theTemp = String.fromCharCode(temp);
      qrContent += theTemp;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: widget.userData.permissions == 1 || widget.userData.permissions == 2 ? SizeConfig.blockSizeVertical * 145 : SizeConfig.blockSizeVertical * 100,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ReturnButton(),
                  Spacer(),
                  widget.userData.permissions == 2 ? IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.edit, color: Theme.of(context).primaryColor,), 
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEvent(event: event, type: event.type == "clubDates" ? "club" : "edit",)));
                    }
                  ) : Container(),
                  widget.userData.permissions == 2 ? IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.delete, color: Theme.of(context).primaryColor), 
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Text("Are you sure you would like to delete this event? There is no way to recover this event once it is deleted"),
                            actions: [
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Cancel")
                              ),
                              FlatButton(
                                onPressed: () async {
                                  await Firestore.instance.collection('events').document(event.date + event.title).delete();
                                }, 
                                child: Text("Delete", style: TextStyle(color: Colors.red),)
                              )
                            ],
                          );
                        }
                      );
                    }
                  ) : Container()
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(event.type == "clubDates") {
                        if(widget.userData.permissions == 4) {
                          bottomOfCard = "";
                        }
                        else if(x == 0) { 
                          x = 1;
                          bottomOfCard = "Tap to show details";
                        }
                        else {
                          x = 0;
                          bottomOfCard = "Tap to show QR Code";
                        }
                      }
                      else {
                        if(widget.userData.permissions == 4 || !event.participates.contains(widget.userData.uid)) {
                          bottomOfCard = "";
                        }
                        else if(x == 0) { 
                          x = 1;
                          bottomOfCard = "Tap to show details";
                        }
                        else {
                          x = 0;
                          bottomOfCard = "Tap to show QR Code";
                        }
                      }
                    });
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 60,
                    width: SizeConfig.blockSizeHorizontal * 85,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Theme.of(context).primaryColor,
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget> [
                            Text(title, style: TextStyle(fontSize: 32, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                            Text(event.date, style: TextStyle(fontSize: 25, color: Theme.of(context).accentColor),),
                            Padding(padding: EdgeInsets.all(2)),
                            x == 0 ? Text(event.type == "clubDates" ? "Agenda" : "Description", style: TextStyle(fontSize: 35, color: Colors.white, decoration: TextDecoration.underline),) : Container(),
                            x == 0 ? Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  description, 
                                  style: TextStyle(fontSize: 20, color: Colors.white), 
                                  textAlign: TextAlign.center,),
                              ),
                            ) : Container(),
                            x == 1 ? Expanded(child: QrImage(data: qrContent, foregroundColor: Colors.white,)) : Container(),
                            widget.userData.permissions > 3 || !event.participates.contains(widget.userData.uid) ? Container() : SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 100,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  bottomOfCard, 
                                  style: TextStyle(
                                    fontSize: 30, 
                                    color: Theme.of(context).accentColor, 
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                              ),
                            ),
                            event.type == 'clubDates' && widget.userData.permissions < 4 ? SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 100,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  bottomOfCard, 
                                  style: TextStyle(
                                    fontSize: 30, 
                                    color: Theme.of(context).accentColor, 
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                              ),
                            ) : Container()
                          ]
                        ),
                      )
                    )
                  ),
                ),
              ),
              show == false || widget.userData.permissions > 1 || event.type == "clubDates" ? Container() : signUpButton(event, user),
              (widget.userData.permissions == 1 || widget.userData.permissions == 2) && event.type != "clubDates" ? viewParticipates(event.participatesName, event.participatesInfo, event.informationDialog) : Container(),
            ]
          ),
        ),
      ),
    );
  }

  Widget viewParticipates(List participates, List participatesInfo, bool informationDialog) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 2, 0, 0)),
          Text("Participants", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30, fontWeight: FontWeight.bold, ),),
          Center(
            child: Container(
              height: SizeConfig.blockSizeVertical * 40,
              child: participates.length == 0 ? Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text("NO PARTICIPANTS", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 25),),
              ) : ListView.builder(
                padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 5, 0, SizeConfig.blockSizeHorizontal * 5, 0),
                itemCount: participates.length,
                itemBuilder: (_, i) {
                  return Card(
                    color: Theme.of(context).primaryColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(participates[i], style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20)),
                          informationDialog == true ? Text(participatesInfo[i], style: TextStyle(color: Theme.of(context).accentColor)) : Container()
                        ],
                      ),
                      leading: Text((i + 1).toString() + ".", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 25),),
                    ),
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget signUpButton(Events event, User user) {
    String _info; 

    return Builder(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Center(
            child: GestureDetector(
              onTap: () async {
                if(signUp == "EVENT FULL") {
                  
                }
                else if(signUp == "SIGNED UP") {

                }
                else {
                  if(event.informationDialog == true) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Signing Up"),
                          content: SingleChildScrollView(
                            child: Container(
                              height: SizeConfig.blockSizeVertical * 75,
                              child: Column(
                                children: <Widget>[
                                  Text("The creator of this event has requested that you add submit information when you sign up. Check the description for what to include in this text box.", textAlign: TextAlign.center,),
                                  Material(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 2, SizeConfig.blockSizeVertical * 4, SizeConfig.blockSizeHorizontal * 2, 0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter information here...',
                                      ),
                                        onChanged: (val) => _info = (val),
                                        validator: (val) => val.isEmpty ? 'Enter Title' : null,
                                        initialValue: _info,
                                      ),
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(), 
                              child: Text("CANCEL")
                            ),
                            FlatButton(
                              onPressed: () async {
                                List participates = new List();
                                List participatesInfo = new List();
                                List participatesName = new List();
                                participates = event.participates;
                                participatesInfo = event.participatesInfo;
                                participatesName = event.participatesName;
                                participates.add(user.uid);
                                participatesInfo.add(_info);
                                participatesName.add(widget.userData.firstName + " " + widget.userData.lastName);
                                await EventService().addParticipateswithInfo(participates, event.title, event.date, participatesInfo, participatesName, event.key.toString());
                                Navigator.of(context).pop();
                                super.setState(() {
                                  show = false;
                                });
                              }, 
                              child: Text("SUBMIT")
                            )
                          ],
                        );
                      }
                    );
                  }
                  else {
                    List participates = new List();
                    List participatesName = new List();
                    participates = event.participates;
                    participatesName = event.participatesName;
                    participates.add(user.uid);
                    participatesName.add(widget.userData.firstName + " " + widget.userData.lastName);
                    await EventService().addParticipates(participates, event.title, event.date, participatesName, event.key.toString());
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Signed Up", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 25),),
                        backgroundColor: Theme.of(context).primaryColor,
                        duration: Duration(seconds: 3),
                      )
                    );
                    super.setState(() {
                      show = false;
                    });
                  }
                }
              },
              child: Container(
                height: 60,
                width: SizeConfig.blockSizeHorizontal * 70,
                color: Colors.transparent,
                child: Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(signUp, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35), textAlign: TextAlign.center,)),
                )
              ),
            ),
          ),
        );
      }
    );
  }
}
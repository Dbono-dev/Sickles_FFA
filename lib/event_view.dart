import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ffa_app/user.dart';

class EventViewPage extends StatefulWidget {

  EventViewPage({this.snapshot, this.userData});

  final DocumentSnapshot snapshot;
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

    if(widget.snapshot.data['participates'].length == int.parse(widget.snapshot.data['max participates'])) {
      signUp = "EVENT FULL";
    }

    if(widget.snapshot.data['participates'].contains(user.uid)) {
      show = false;
    }

    String theQrContent = widget.snapshot.data['title'] + "/" + widget.userData.uid + "/" + widget.userData.firstName + " " + widget.userData.lastName;
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
          height: SizeConfig.blockSizeVertical * 100,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              ReturnButton(),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(widget.userData.permissions >= 1 || !widget.snapshot.data['participates'].contains(widget.userData.uid)) {
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
                            Text(widget.snapshot.data['title'], style: TextStyle(fontSize: 32, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                            Text(widget.snapshot.data['date'], style: TextStyle(fontSize: 27.5, color: Theme.of(context).accentColor),),
                            Padding(padding: EdgeInsets.all(2)),
                            x == 0 ? Text("Description", style: TextStyle(fontSize: 35, color: Colors.white, decoration: TextDecoration.underline),) : Container(),
                            x == 0 ? Text(widget.snapshot.data['description'], style: TextStyle(fontSize: 25, color: Colors.white), textAlign: TextAlign.center,): Container(),
                            x == 1 ? QrImage(data: qrContent, foregroundColor: Colors.white, size: SizeConfig.blockSizeVertical * 30,) : Container(),
                            Spacer(),
                            widget.userData.permissions >= 1 || !widget.snapshot.data['participates'].contains(widget.userData.uid) ? Container() : SizedBox(
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
                            )
                          ]
                        ),
                      )
                    )
                  ),
                ),
              ),
              show == false || widget.userData.permissions == 2 || widget.userData.permissions == 1 || widget.userData.permissions == 3 ? Container() : Builder(
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          if(signUp == "EVENT FULL") {
                            
                          }
                          else {
                            if(widget.snapshot.data['information dialog'] == true) {
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
                                          participates = widget.snapshot.data['participates'];
                                          participates.add(user.uid);
                                          await EventService().addParticipates(participates, widget.snapshot.data['title'], widget.snapshot.data['date']);
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
                              participates = widget.snapshot.data['participates'];
                              participates.add(user.uid);
                              await EventService().addParticipates(participates, widget.snapshot.data['title'], widget.snapshot.data['date']);
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
              ),
            ]
          ),
        ),
      ),
    );
  }
}
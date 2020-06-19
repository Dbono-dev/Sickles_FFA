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

  DocumentSnapshot snapshot;
  UserData userData;

  @override
  _EventViewPageState createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  int x = 0;
  String bottomOfCard = "Tap to show QR Code";
  bool show = true;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    if(widget.snapshot.data['participates'].contains(user.uid)) {
      show = false;
    }

    String theQrContent = widget.snapshot.data['title'] + "/" + widget.userData.uid + "/" + widget.userData.firstName + " " + widget.userData.lastName;
    String qrContent = "";

    List<int> theListOfInts = new List<int> ();

    for(int i = 0; i < theQrContent.length; i++) {
      var char = theQrContent[i];
      int temp = char.codeUnitAt(0) + 5;
      theListOfInts.add(temp);
      String theTemp = String.fromCharCode(temp);
      qrContent += theTemp;
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            ReturnButton(),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if(x == 0) {
                      x = 1;
                      bottomOfCard = "Tap to show details";
                    }
                    else {
                      x =0;
                      bottomOfCard = "Tap to show QR Code";
                    }
                  });
                },
                child: Container(
                  height: 375,
                  width: 350,
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
                          x == 1 ? QrImage(data: qrContent, foregroundColor: Colors.white, size: 200,) : Container(),
                          Spacer(),
                          Text(bottomOfCard, style: TextStyle(fontSize: 30, color: Theme.of(context).accentColor, decoration: TextDecoration.underline),)
                        ]
                      ),
                    )
                  )
                ),
              ),
            ),
            show == false ? Container() : Builder(
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
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
                      },
                      child: Container(
                        height: 60,
                        width: SizeConfig.blockSizeHorizontal * 70,
                        color: Colors.transparent,
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Center(child: Text("SIGN UP", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35), textAlign: TextAlign.center,)),
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
    );
  }
}
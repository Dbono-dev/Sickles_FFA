import 'package:ffa_app/main.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventViewPage extends StatefulWidget {
  @override
  _EventViewPageState createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  int x = 0;
  String bottomOfCard = "Tap to show QR Code";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Padding(padding: EdgeInsets.fromLTRB(0, 35, 0, 0)),
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
                  color: Theme.of(context).primaryColor,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget> [
                        Text("Club Meeting", style: TextStyle(fontSize: 35, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),),
                        Text("Date", style: TextStyle(fontSize: 35, color: Theme.of(context).accentColor),),
                        Padding(padding: EdgeInsets.all(2)),
                        x == 0 ? Text("Agenda", style: TextStyle(fontSize: 35, color: Colors.white, decoration: TextDecoration.underline),) : Container(),
                        x == 0 ? Text("This is just some text to show where the agenda would go", style: TextStyle(fontSize: 25, color: Colors.white), textAlign: TextAlign.center,): Container(),
                        x == 1 ? QrImage(data: "This is a test", foregroundColor: Colors.white, size: 225,) : Container(),
                        Spacer(),
                        Text(bottomOfCard, style: TextStyle(fontSize: 30, color: Theme.of(context).accentColor, decoration: TextDecoration.underline),)
                      ]
                    ),
                  )
                )
              ),
            ),
          )
        ]
      ),
    );
  }
}
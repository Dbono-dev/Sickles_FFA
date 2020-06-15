import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Text("Feed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55, color: Theme.of(context).accentColor, decoration: TextDecoration.underline))
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                width: 400,
                height: 250,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Column(
                      children: <Widget> [
                        Padding(padding: EdgeInsets.all(3.5)),
                        Text("Title", style: TextStyle(fontSize: 35, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),),
                        Text("This is where the message would go!", style: TextStyle(fontSize: 30, color: Theme.of(context).accentColor), textAlign: TextAlign.center,)
                      ]
                    ),
                  ),
                ) 
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Container(
                width: 400,
                height: 250,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Column(
                      children: <Widget> [
                        Padding(padding: EdgeInsets.all(3.5)),
                        Text("Title", style: TextStyle(fontSize: 35, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),),
                        Text("This is where the message would go!", style: TextStyle(fontSize: 30, color: Theme.of(context).accentColor), textAlign: TextAlign.center,)
                      ]
                    ),
                  ),
                ) 
              ),
            )
          ]
        ),
      ),
    );
  }
}
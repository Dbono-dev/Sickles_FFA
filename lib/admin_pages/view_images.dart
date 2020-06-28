import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';

class ViewImages extends StatelessWidget {
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("upload pics").getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ReturnButton(),
          Padding(padding: EdgeInsets.all(10)),
          Center(
            child: FutureBuilder(
              future: getPosts(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                else {
                  return SizedBox(
                    height: 560,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      itemBuilder: (_, index) {
                        return imageCards(context, snapshot.data[index]);
                      }
                    ),
                  );
                }
              }
            )
          )
        ],
      ),
    );
  }

  Widget imageCards(BuildContext context, DocumentSnapshot snapshot) {

    DateTime dateTime = snapshot.data['dateTime'].toDate();

    return Container(
      height: 250,
      width: SizeConfig.blockSizeHorizontal * 85,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("From: " + snapshot.data['name'], style: TextStyle(color: Theme.of(context).accentColor)),
                  Spacer(),
                  Text(dateTime.month.toString() + "/" + dateTime.day.toString() + "/" + dateTime.year.toString() + " @ " + dateTime.hour.toString() + ":" + dateTime.minute.toString(), style: TextStyle(color: Theme.of(context).accentColor),)
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Image.network(
                snapshot.data['url'],
                fit: BoxFit.fitHeight,
                height: 180,
                loadingBuilder:(BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor)
                      ),
                    );
                  },
              ),
            )
          ],
        ),
      ),
    );
  }
}
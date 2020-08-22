import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ViewImages extends StatelessWidget {
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("upload pics").orderBy('dateTime', descending: true).getDocuments();
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
                    height: SizeConfig.blockSizeVertical * 80,
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
      height: SizeConfig.blockSizeVertical * 40,
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
              child: GestureDetector(
                onLongPress: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              padding: EdgeInsets.only(bottom: 10),
                              icon: Icon(Icons.save_alt, color: Colors.white, size: 45,),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                var response = await get(snapshot.data['url']);
                                var documentDirectory = await getApplicationDocumentsDirectory();

                                File file = new File(
                                  join(documentDirectory.path, snapshot.data['name'] + dateTime.month.toString() + "-" + dateTime.day.toString() + "-" + dateTime.year.toString() + '.png')
                                );

                                file.writeAsBytesSync(response.bodyBytes);
                              },
                            ),
                          ),
                          Image.network(
                            snapshot.data['url'],
                            height: SizeConfig.blockSizeVertical * 80,
                            width: SizeConfig.blockSizeHorizontal * 80,
                          ),
                        ],
                      );
                    }
                  );
                },
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
              ),
          ],
        ),
      ),
    );
  }
}
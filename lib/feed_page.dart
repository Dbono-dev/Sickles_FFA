import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedPage extends StatelessWidget {

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("posts").getDocuments();
    
    return qn.documents;
  }

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
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Text("Feed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55, color: Theme.of(context).accentColor, decoration: TextDecoration.underline))
            ),
            FutureBuilder(
              future: getPosts(),
              builder: (_, index) {
                if(index.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else {
                  return Container(
                    height: SizeConfig.blockSizeVertical * 75,
                    child: index.data.length == 0 ? Center(
                      child: Text("NO POSTS", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35, fontWeight: FontWeight.bold),),
                      ) : ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: index.data.length,
                      itemBuilder: (_, snapshot) {
                        return feedTile(context, index.data[snapshot]);
                      }
                    ),
                  );
                }
              },
            )
          ]
        ),
      ),
    );
  }

  Widget feedTile(BuildContext context, DocumentSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 80,
        height: SizeConfig.blockSizeVertical * 40,
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
                Text(snapshot.data['title'], style: TextStyle(fontSize: 35, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),),
                Container(
                  height: SizeConfig.blockSizeVertical * 23, 
                  child: SingleChildScrollView(
                    child: Text(snapshot.data['description'], 
                    style: TextStyle(fontSize: 25, color: Theme.of(context).accentColor),
                    textAlign: TextAlign.center,
                    )
                  )
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => launch("http://" + snapshot.data['link']),
                  child: Text(snapshot.data['link'], style: TextStyle(fontSize: 30, color: Theme.of(context).accentColor, decoration: TextDecoration.underline),)
                )
              ]
            ),
          ),
        ) 
      ),
    );
  }
}
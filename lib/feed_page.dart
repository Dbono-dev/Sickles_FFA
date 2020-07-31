import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/admin_pages/add_post.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ffa_app/user.dart';

class FeedPage extends StatefulWidget {

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("posts").orderBy('dateTime', descending: true).getDocuments();
    
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserData userData = snapshot.data;
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
                              return feedTile(context, index.data[snapshot], userData);
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
        else {
          return CircularProgressIndicator();
        }
      }
    );
  }

  Widget feedTile(BuildContext context, DocumentSnapshot snapshot, UserData userData) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: GestureDetector(
        onLongPress: () {
          userData.permissions == 2 ? showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: SizeConfig.blockSizeVertical * 17.5,
                child: Column(
                  children: [
                    FlatButton.icon(
                      label: Text("EDIT"),
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPost(
                          title: snapshot.data['title'],
                          oGTitle: snapshot.data['oGTitle'],
                          description: snapshot.data['description'],
                          link: snapshot.data['link'],
                          dateTime: snapshot.data['dateTime'],
                          edit: true,
                        )));
                      },
                    ),
                    FlatButton.icon(
                      label: Text("DELETE", style: TextStyle(color: Colors.red),),
                      icon: Icon(Icons.delete, color: Colors.red,),
                      onPressed: () async {
                        showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Text("Are you sure you would like to delete this post? There is no way to recover this post once it is deleted", textAlign: TextAlign.center,),
                            actions: [
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Cancel")
                              ),
                              FlatButton(
                                onPressed: () async {
                                  await PostService().deletePost(snapshot.data['dateTime'], snapshot.data['oGTitle']);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  setState(() {
                                    
                                  });
                                }, 
                                child: Text("Delete", style: TextStyle(color: Colors.red),)
                              )
                            ],
                          );
                        }
                      );
                      },
                    )  
                  ],
                ),
              );
            }
          ) : Container();
        },
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
      ),
    );
  }
}
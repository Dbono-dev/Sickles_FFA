import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/member_pages/send_message.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';

class ViewMessages extends StatelessWidget {

  List<DocumentSnapshot> firstCollection;
  List<DocumentSnapshot> secondCollection;

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("messages").getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> theMessagesWidget = new List<Widget>();

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ReturnButton(),
          Padding(padding: EdgeInsets.all(15)),
          Container(
            height: SizeConfig.blockSizeVertical * 60,
            child: FutureBuilder(
              future: getPosts(),
              builder: (_, index) {
                if(index.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else {
                  for(int i = 0; i < index.data.length; i++) {
                    String receiverName = index.data[i].data['name'];
                    String description = index.data[i].data['text'];
                    String date = index.data[i].data['date'];
                    String uid = index.data[i].data['uid'];
                    theMessagesWidget.add(_conversationPreviews(context, receiverName, description, date, uid));
                  }
                  if(theMessagesWidget.length > 0) {
                    return ListView.builder(
                      itemCount: theMessagesWidget.length,
                      itemBuilder: (_, index) {
                        return theMessagesWidget[index];
                      },
                    );
                  }
                  else {
                    return Container(
                      child: Center(
                        child: Text("No Messages", style: TextStyle(fontSize: 30),)
                      ),
                    );
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _conversationPreviews(BuildContext context, String receiverName, String description, String date, String uid) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendMessages(type: "officer", receiverName: receiverName, uid: uid)));
      },
      child: Card(
        elevation: 10,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: ListTile( 
            leading: Text(receiverName, style: TextStyle(fontWeight: FontWeight.bold),),
            title: Text(description, overflow: TextOverflow.ellipsis,),
            trailing: Text(date.substring(0, 10), style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}
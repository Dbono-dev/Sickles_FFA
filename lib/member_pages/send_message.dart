import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:ffa_app/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class SendMessages extends StatefulWidget {

  SendMessages({this.type, this.receiverName, this.uid});

  final String type;
  final String receiverName;
  final String uid;

  @override 
  _SendMessagesState createState() => _SendMessagesState();
}

class _SendMessagesState extends State<SendMessages> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  String sender;
  String reciever;
  String senderName;
  String recieverName;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    SizeConfig().init(context);

    return StreamBuilder<Object>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        UserData userData = snapshot.data;
        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(),);
        }
        else {
          widget.type == "officer" ? senderName = "Leadership" : senderName = userData.firstName + " " + userData.lastName;
          widget.type == "officer" ? recieverName = widget.receiverName : recieverName = "Leadership";

          widget.type == "officer" ? sender = "Leadership" : sender = userData.uid;
          widget.type == "officer" ? reciever = widget.uid : reciever = "Leadership";

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: Card(
                color: Theme.of(context).primaryColor,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Center(
                  child: IconButton(
                    alignment: Alignment.center,
                    iconSize: 35,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              centerTitle: true,
              title: Material(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    recieverName, 
                    style: TextStyle(fontSize: 40, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                  )
                )
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: SizeConfig.blockSizeVertical * 100,
                width: SizeConfig.blockSizeHorizontal * 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 97.5,
                      height: SizeConfig.blockSizeVertical * 76,
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          height: SizeConfig.blockSizeVertical * 75,
                          child: StreamBuilder<QuerySnapshot> (
                            stream: _firestore.collection('messages').document(widget.uid).collection('theMessages').snapshots(),
                            builder: (context, snapshot) {
                              if(!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.grey),),);
                              }
                              else {
                                List docs = snapshot.data.documents;

                                List<Widget> messages = docs.map((doc) => Message(
                                  from: doc.data['from'],
                                  text: doc.data['text'],
                                  me: sender == doc.data['from'],
                                )).toList();

                                return ListView(
                                  reverse: true,
                                  controller: scrollController,
                                  children: <Widget>[
                                    ... messages.reversed.toList(),
                                  ],
                                ); 
                                
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                          ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                border: Border.all(color: Theme.of(context).primaryColor)
                              ),
                              width: SizeConfig.blockSizeHorizontal * 90,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: SizeConfig.blockSizeHorizontal * 70,
                                    height: SizeConfig.blockSizeVertical * 7,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: TextFormField(
                                        expands: true,
                                        maxLines: null,
                                        minLines: null,
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          hintText: "Message...",
                                          border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: SizeConfig.blockSizeHorizontal * 18,
                                    child: RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      onPressed: () async {
                                        if(messageController.text.length > 0) {
                                          try {
                                            widget.type == "officer" ? await _firestore.collection('messages').document(widget.uid).updateData({    
                                              'text': messageController.text,
                                              'date': DateTime.now().toString(),
                                            }) : await _firestore.collection('messages').document(userData.uid).updateData({
                                              'uid': userData.uid,
                                              'text': messageController.text,
                                              'date': DateTime.now().toString(),
                                              'name': userData.firstName + " " + userData.lastName
                                            });
                                          }
                                          catch (e) {
                                            widget.type == "officer" ? await _firestore.collection('messages').document(widget.uid).setData({    
                                              'text': messageController.text,
                                              'date': DateTime.now().toString(),
                                            }) : await _firestore.collection('messages').document(userData.uid).setData({
                                              'uid': userData.uid,
                                              'text': messageController.text,
                                              'date': DateTime.now().toString(),
                                              'name': userData.firstName + " " + userData.lastName
                                            });
                                          }
                                          widget.type == "officer" ? await _firestore.collection('messages').document(widget.uid).collection('theMessages').document(DateTime.now().toString()).setData({
                                            'text': messageController.text,
                                            'from': sender,
                                            'dateTime': DateTime.now()
                                          }) : await _firestore.collection('messages').document(userData.uid).collection('theMessages').document(DateTime.now().toString()).setData({
                                            'text': messageController.text,
                                            'from': sender,
                                            'dateTime': DateTime.now()});
                                          messageController.clear();
                                          //scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                                        }
                                      },
                                      child: Text("Send", style: TextStyle(color: Theme.of(context).accentColor),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ),
                    )
                  ]
                ),
              ),
            ),
          );
        }
      }
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(me ? SizeConfig.blockSizeHorizontal * 20 : 8, 8, me ? 8 : SizeConfig.blockSizeHorizontal * 20, 8),
      child: Container(
        child: Column(
          crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget> [
            Material(
              color: me ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(text, style: TextStyle(color: Colors.white),),
              )
            ),
          ]
        ),
      ),
    );
  }
}
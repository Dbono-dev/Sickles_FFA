
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/database.dart';

class ScannedData {

  ScannedData({this.text, this.date});

  String text;
  String date;
  List<String> qrCodeItems = new List<String>(); 
  String title;
  String name;
  String time;
  String type;
  String uid;
  String oldDate;
  List participates = new List();
  String theText = "";

  Future<List> resisterScanData() async {
    /*for(int i = 0; i < text.length; i++) {
      var char = text[i];
      int temp = char.codeUnitAt(0) - 5;
      String theTemp = String.fromCharCode(temp);
      theText += theTemp;
    }*/

    for(int i = 0; i < text.length; i++) {
      if(text.substring(0, i).contains("/")) {
        qrCodeItems.add(text.substring(0, i - 1));
        text = text.substring(i);
        i = 0;
      }
      else if(i == text.length - 1) {
        qrCodeItems.add(text);
      }
    }

    qrCodeItems.add(date);

    title = qrCodeItems[0];
    uid = qrCodeItems[1];
    name = qrCodeItems[2];

    return qrCodeItems;

  }

  Future saveScanningSession() async {
    /*for(int i = 0; i < text.length; i++) {
      var char = text[i];
      int temp = char.codeUnitAt(0) - 5;
      String theTemp = String.fromCharCode(temp);
      theText += theTemp;
    }*/

    for(int i = 0; i < text.length; i++) {
      if(text.substring(0, i).contains("/")) {
        qrCodeItems.add(text.substring(0, i - 1));
        text = text.substring(i);
        i = 0;
      }
      else if(i == text.length - 1) {
        qrCodeItems.add(text);
      }
    }

    qrCodeItems.add(date);

    title = qrCodeItems[0];
    uid = qrCodeItems[1];
    name = qrCodeItems[2];

    List eventTitle = new List();
    List eventDate = new List();

    QuerySnapshot qn = await Firestore.instance.collection('members').getDocuments();
    for(int i = 0; i < qn.documents.length; i++) {
      DocumentSnapshot snapshot = qn.documents[i];
      if(snapshot.data['uid'] == uid) {
        eventTitle = snapshot.data['event title'];
        eventDate = snapshot.data['event date'];
      }
    }

    eventTitle.add(title);
    eventDate.add(date);

    await DatabaseService(uid: uid).addCompletedEvent(eventTitle, eventDate);
  }

  Future submitScanningSession() async {
    /*for(int i = 0; i < text.length; i++) {
      var char = text[i];
      int temp = char.codeUnitAt(0) - 5;
      String theTemp = String.fromCharCode(temp);
      theText += theTemp;
    }*/

    for(int i = 0; i < text.length; i++) {
      if(text.substring(0, i).contains("/")) {
        qrCodeItems.add(text.substring(0, i - 1));
        text = text.substring(i);
        i = 0;
      }
      else if(i == text.length - 1) {
        qrCodeItems.add(text);
      }
    }

    qrCodeItems.add(date);

    title = qrCodeItems[0];
    uid = qrCodeItems[1];
    name = qrCodeItems[2];

    List eventTitle = new List();
    List eventDate = new List();

    QuerySnapshot qn = await Firestore.instance.collection('members').getDocuments();
    for(int i = 0; i < qn.documents.length; i++) {
      DocumentSnapshot snapshot = qn.documents[i];
      if(snapshot.data['uid'] == uid) {
        eventTitle = snapshot.data['event title'];
        eventDate = snapshot.data['event date'];
      }
    }

    eventTitle.add(title);
    eventDate.add(date);

    await DatabaseService(uid: uid).addCompletedEvent(eventTitle, eventDate);
  }
}
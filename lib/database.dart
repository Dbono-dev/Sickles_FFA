import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference memberCollection = Firestore.instance.collection('members');

  Future updateUserData(String firstName, String lastName, String studentNum, String grade, String uid, String permissions) async {
    return await memberCollection.document(uid).setData({
      'first name': firstName,
      'last name': lastName,
      'grade': grade,
      'student num': int.parse(studentNum),
      'permissions': int.parse(permissions),
      'uid': uid,
      'club attendence': [],
      'event date': [],
      'event title': [],
    });
  }

  Future addCompletedEvent(List eventTitle, List eventDate) async {
    return await memberCollection.document(uid).updateData({
      'event date': eventDate,
      'event title': eventTitle
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.data['uid'],
      clubAttendence: snapshot.data['club attendence'],
      eventDate: snapshot.data['event date'],
      eventTitle: snapshot.data['event title'],
      firstName: snapshot.data['first name'],
      grade: snapshot.data['grade'],
      lastName: snapshot.data['last name'],
      permissions: snapshot.data['permissions'],
      studentNum: snapshot.data['student num']
    );
  }

  Stream<UserData> get userData {
    return memberCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}

class EventService {
  
  final CollectionReference eventsCollection = Firestore.instance.collection('events');

  Future addEvent(String title, String date, String description, String location, String startTime, String endTime, String maxParticipates, String type, bool theSwitch, List participate, List participateName, List participateInfo, String key, String saveSubmit) async {
    Random random = Random.secure();
    var randomNum = random.nextInt(100000);

    print("got here");

    return await eventsCollection.document(saveSubmit == "save" ? key : randomNum.toString()).setData({
      'title': title,
      'date': date, 
      'description': description,
      'location': location,
      'start time': startTime,
      'end time': endTime,
      'max participates': maxParticipates,
      'type': type,
      'participates': participate,
      'participates name': participateName,
      'participates info': participateInfo,
      'information dialog': theSwitch,
      'key': saveSubmit == "save" ? key : randomNum
    });
  }

  Future addParticipateswithInfo(List participates, String title, String date, List participatesInfo, List participatesName, String key) async {
    return await eventsCollection.document(key).updateData({
      'participates': participates,
      'participates info': participatesInfo,
      'participates name': participatesName
    });
  }

  Future addParticipates(List participates, String title, String date, List participatesName, String key) async {
    return await eventsCollection.document(key).updateData({
      'participates': participates,
      'participates name': participatesName
    });
  }
}

class PostService {
  final CollectionReference postCollection = Firestore.instance.collection('posts');

  Future addPost({String title, String description, String link}) async {
    String dateTime = DateTime.now().toString();
    return await postCollection.document(dateTime + title).setData({
      'title': title,
      'description': description,
      'link': link,
      'dateTime': dateTime,
      'oGTitle': title
    });
  }

  Future addPostWithoutLink({String title, String description}) async {
    String dateTime = DateTime.now().toString();
    return await postCollection.document(dateTime + title).setData({
      'title': title,
      'oGTitle': title,
      'description': description,
      'dateTime': dateTime
    });
  }

  Future savePost({String oldTitle, String dateTime, String title, String description, String link}) async {
    return await postCollection.document(dateTime + oldTitle).updateData({
      'title': title,
      'description': description,
      'dateTime': dateTime,
      'link': link
    });
  }

  Future deletePost(String dateTime, String title) async {
    return await postCollection.document(dateTime + title).delete();
  }
}

class BugService {
  final CollectionReference bugsCollection = Firestore.instance.collection('bugs');

  Future reportBug(String bug) async {
    return await bugsCollection.document(DateTime.now().toString()).setData({
      'bug': bug,
      'dateTime': DateTime.now()
    });
  }
}

class OfficerMinutesService {
  final CollectionReference officerMinutes = Firestore.instance.collection('officer minutes');

  Future addOfficerMinutes(String date, String url) async {
    return await officerMinutes.document(date).setData({
      'url': url,
      'date': date
    });
  }
}

class UploadedPictures {
  final CollectionReference uploadPics = Firestore.instance.collection('upload pics');

  Future addPic(dynamic url, String name) async {
    return await uploadPics.document(name + DateTime.now().toString()).setData({
      'url': url,
      'dateTime': DateTime.now(),
      'name': name
    });
  }

  Future addPics(List url, String name) async {
    return await uploadPics.document(name + DateTime.now().toString()).setData({
      'url': url,
      'dateTime': DateTime.now(),
      'name': name
    });
  }
}

class DatabaseImporantDates {
  final CollectionReference importantDates = Firestore.instance.collection('club dates');

  Future setImportantDates(String type, String date, var participates, String agenda) async {
    return await importantDates.document(type + date).setData({
      'type': type,
      'date': date,
      'participates': participates,
      'agenda': agenda
    });
  }

  Future updateImportantDates(String type, String newDate, String oldDate, var participates, String agenda) async {
    await importantDates.document(type + oldDate).delete();
    return setImportantDates(type, newDate, participates, agenda);
  }

  Future updateAgenda(String type, String date, String agenda) async {
    return await importantDates.document(type + date).updateData({
      'agenda': agenda
    });
  }

  Future deleteImportantDates(String type, String date) async {
    return await importantDates.document(type + date).delete();
  }
}
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

  Future addEvent(String title, String date, String description, String location, String startTime, String endTime, String maxParticipates, String type, bool theSwitch) async {
    return await eventsCollection.document(date + title).setData({
      'title': title,
      'date': date, 
      'description': description,
      'location': location,
      'start time': startTime,
      'end time': endTime,
      'max participates': maxParticipates,
      'type': type,
      'participates': [],
      'participates name': [],
      'participates info': [],
      'information dialog': theSwitch
    });
  }

  Future addParticipateswithInfo(List participates, String title, String date, List participatesInfo, List participatesName) async {
    return await eventsCollection.document(date + title).updateData({
      'participates': participates,
      'participates info': participatesInfo,
      'participates name': participatesName
    });
  }

  Future addParticipates(List participates, String title, String date, List participatesName) async {
    return await eventsCollection.document(date + title).updateData({
      'participates': participates,
      'participates name': participatesName
    });
  }
}

class PostService {
  final CollectionReference postCollection = Firestore.instance.collection('posts');

  Future addPost({String title, String description, String link}) async {
    return await postCollection.document(DateTime.now().toString() + title).setData({
      'title': title,
      'description': description,
      'link': link,
      'dateTime': DateTime.now().toString()
    });
  }

  Future addPostWithoutLink({String title, String description}) async {
    return await postCollection.document(DateTime.now().toString() + title).setData({
      'title': title,
      'description': description,
      'dateTime': DateTime.now().toString()
    });
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

  Future setImportantDates(String type, String date, var participates) async {
    return await importantDates.document(type + date).setData({
      'type': type,
      'date': date,
      'participates': participates
    });
  }

  Future updateImportantDates(String type, String newDate, String oldDate, var participates) async {
    await importantDates.document(type + oldDate).delete();
    return setImportantDates(type, newDate, participates);
  }

  Future deleteImportantDates(String type, String date) async {
    return await importantDates.document(type + date).delete();
  }
}
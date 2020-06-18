import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference memberCollection = Firestore.instance.collection('members');

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

  Future addEvent(String title, String date, String description, String location, String startTime, String endTime, String maxParticipates, String type) async {
    return await eventsCollection.document(title + date).setData({
      'title': title,
      'date': date, 
      'description': description,
      'location': location,
      'start time': startTime,
      'end time': endTime,
      'max participates': maxParticipates,
      'type': type,
      'participates': []
    });
  }

  Future addParticipates(List participates, String title, String date) async {
    return await eventsCollection.document(title + date).updateData({
      'participates': participates
    });
  }
}

class PostService {
  final CollectionReference postCollection = Firestore.instance.collection('posts');

  Future addPost({String title, String description, String link}) async {
    return await postCollection.document(title).setData({
      'title': title,
      'description': description,
      'link': link
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
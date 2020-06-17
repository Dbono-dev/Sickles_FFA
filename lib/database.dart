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
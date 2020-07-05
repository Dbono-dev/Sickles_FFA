class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final List eventDate;
  final List eventTitle;
  final String firstName;
  final String lastName;
  final String grade;
  final List clubAttendence;
  final int permissions;
  final int studentNum;

  UserData({this.uid, this.eventDate, this.eventTitle, this.firstName, this.lastName, this.grade, this.clubAttendence, this.permissions, this.studentNum});
}
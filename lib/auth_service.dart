import 'package:firebase_auth/firebase_auth.dart';
import 'package:ffa_app/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future logout() async {
    try {
      return await _auth.signOut();
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future loginUser({String email, String password}) async{
    try {
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();
  }

  Future resetPassword({String theEmail}) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String email = user.email;
      var result = await _auth.sendPasswordResetEmail(email: email);
    }
    catch (e) { 
      var result = await _auth.sendPasswordResetEmail(email: theEmail);
      print(e.toString());
    }
  }

  Future createUser({String email, String password}) async {
    var r = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    //await DatabaseService(uid: r.user.uid).updateUserData();
  }
}
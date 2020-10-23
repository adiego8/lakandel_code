 import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   ///Authentication method
  Future authenticate(String email, String password) async {
    var result = true;
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
      if(value.user.uid == null){
        result = false;
      }
    });
    return result;
  }

  ///Sign out Current user
  void signout() async {
    _firebaseAuth.signOut();
  }

  //Check if there is a current user
  bool isAuthorized() {
    var result = _firebaseAuth.currentUser;
    if(result == null){
      return false;
    } else {
      return true;
    }
  }

 }
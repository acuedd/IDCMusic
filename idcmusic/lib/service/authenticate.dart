

import 'package:church_of_christ/service/base_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class Authentication with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  GoogleSignIn _googleSignIn;
  Status _status = Status.Uninitialized;
  bool _logged = false;

  Authentication.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;
  bool get logged => _logged;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    bool boleano = false;
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) async{
        print(value);
        print("here voy");
        User myUser = value.user;

        final email = myUser.email.split("@");

        Map<dynamic, dynamic> response = await BaseRepository.registerUser(
                username: email[0].toString(),  
                email: myUser.email,
                firstname: myUser.displayName, 
                lastname: myUser.displayName, 
                phone: myUser.phoneNumber,
                token: myUser.uid,
              );        

        if(response["valido"] == 1){
          var sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("userloged", response["userid"]); 
        }
        
      });
      boleano =  true;
    } catch (e) {
      var sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.remove("userloged");
      print("ERROR\n");
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      boleano = false;
    }

    return boleano;
  }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    _logged = (_status == Status.Authenticated);
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _logged = (_status == Status.Authenticated);
    }
    notifyListeners();
  }

}
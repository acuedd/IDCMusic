

import 'dart:io';

import 'package:church_of_christ/service/base_repository.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info/package_info.dart';
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
        debugPrint("$myUser");

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
          sharedPreferences.setString("googleUID", myUser.uid); 

          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String version = packageInfo.version;
          String packageName = packageInfo.packageName;
          String appName = packageInfo.appName;
          String os = Platform.operatingSystem;
          String device_id = await _getId();


          Map<dynamic, dynamic> responseLogin = await BaseRepository.login(
            username: email[0].toString(), 
            password: myUser.uid, 
            appversion: version, 
            appname: packageName, 
            os: os,
            device_id: device_id
          );
          
          if(responseLogin["valido"] == 1){
            sharedPreferences.setString("tokenGenius", responseLogin["udid"]); 
          }
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

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  Future signOut() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("userloged"); 
    sharedPreferences.remove("googleUID"); 
    sharedPreferences.remove("tokenGenius"); 
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
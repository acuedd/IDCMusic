
import 'dart:io';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:church_of_christ/service/authenticate.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLibrary extends StatefulWidget{
  
  final bool login; 

   UserLibrary({this.login});

  @override
  _UserLibraryState createState() => _UserLibraryState();
}

class _UserLibraryState extends State<UserLibrary> {

  @override
  void initState() {
    super.initState();
    checkUserLoginGenius();    
  }

  Future checkUserLoginGenius() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    String tokenGenius = sharedPreferences.get("tokenGenius") ?? "";
    if(tokenGenius != null && tokenGenius.isEmpty){
      String userid = sharedPreferences.get("userloged") ?? "";

      if(userid != null && userid.isNotEmpty){
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        String version = packageInfo.version;
        String packageName = packageInfo.packageName;
        String appName = packageInfo.appName;
        String os = Platform.operatingSystem;
        String device_id = await _getId();

        Map<dynamic, dynamic> responseLogin = await BaseRepository.loginWidthUid(
          userid: userid,
          appversion: version, 
          appname: packageName, 
          os: os,
          device_id: device_id
        );
        if(responseLogin["valido"] == 1){
            sharedPreferences.setString("tokenGenius", responseLogin["udid"]); 
          }
      }      
    }
  }

  Future syncSongsPerUser() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    String tokenGenius = sharedPreferences.get("tokenGenius") ?? "";
    if(tokenGenius != null && tokenGenius.isNotEmpty){
      DateTime _now = DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(_now);
      var formater2 = new DateFormat('hh:mm:ss');
      String formatterDate = formater2.format(_now);
      Map<dynamic, dynamic> response = await BaseRepository.checkUpDateFavoriteList(
          token: tokenGenius,
          date: formattedDate,
          time: formatterDate,
        );
      if(response!= null && response["valido"] == 1 && response["needUpdate"] == true){
        FavoriteModel favoriteModel = Provider.of(context, listen: false);
        if(favoriteModel.favoriteSong.length > 0){
          debugPrint("${favoriteModel.favoriteSong.length}");
        }
      }
    }    
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

  @override
  Widget build(BuildContext context) {

    if(widget.login){
      return userProfile();
    }
    else{
      return loginButton();
    }
  
  }

  Widget loginButton(){
  final user = Provider.of<Authentication>(context);

  return Container(
          child: Center(
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                user.signOut();
                if (await user.signInWithGoogle()){
                  //print("fuck im here");
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/images/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Login con Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
}
  
  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }

  Widget userProfile(){
    double screenWidth = MediaQuery.of(context).size.width;
    bool screenAspectRatio = true;    
    if(screenWidth <= 350){
      screenAspectRatio = false;
    }

    final myUser = Provider.of<Authentication>(context);
    final keyTooltip = GlobalKey<State<Tooltip>>();
    final String strMessage = "Guarda en línea tus canciones favoritas.";
    final int intLenName = myUser.user.displayName.length;
    debugPrint("LEN $intLenName");
    double c_width = MediaQuery.of(context).size.width;
    String displayName = myUser.user.displayName;
    if(intLenName > 18){
      int limitLen = (screenAspectRatio)?18:12;
      displayName = myUser.user.displayName.substring(0,limitLen) + "...";
    }    

    return  Card(
      color: (Theme.of(context).brightness == Brightness.dark)? Colors.grey[600] : Colors.grey[300],
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        height: 100,
        alignment: Alignment.center,
        width: c_width,
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Tooltip(
                  message: strMessage, 
                  child: CircleAvatar( 
                      radius: 40,
                      backgroundImage: Utils.image(myUser.user.photoURL, justprovide:true),
                  ),
                ),                             
                const SizedBox( width: 10,),
                Tooltip(
                  key: keyTooltip,
                  message: strMessage, 
                  child: InkWell(
                    onTap: () => _onTap(keyTooltip),
                    child:   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,                    
                      children: [
                        Container(
                          child: Text(
                            "¡Hola! \nDios te bendiga ",
                            style: GetTextStyle.L(context),
                          ),
                        ),   
                        Text(
                          "$displayName" ,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style:GetTextStyle.L(context),
                        ),
                      ]
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => myUser.signOut(),                   
                  icon: Icon(                     
                    Icons.logout
                  )
                ),
              ],
            ),            
          ],
        ),
      ),
    );    
  }
}

import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider{
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;
  static StreamController<String> _mensajesStreamController = StreamController.broadcast();
  static Stream<String> get mensajes => _mensajesStreamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async{
    print("-----onBackground----");
    String argumento = "no-data";
    String cuerpo = "no-data";
    String modulo = "no-data";
    String moduloParams = "no-data";

    argumento = message.data['objeto'] ?? 'no-data';
    cuerpo = message.data['cuerpo'] ?? 'no-data';
    modulo = message.data['modulo'] ?? 'no-data';

    _mensajesStreamController.sink.add(argumento + "&nbsp" + cuerpo + "&nbsp" + modulo);
  }

  static Future _onMessageHandler(RemoteMessage message) async{
    print('----- onResume -----');
    String argumento = "no-data";
    String cuerpo = "no-data";
    String modulo = "no-data";
    String moduloParams = "no-data";

    argumento = message.data['objeto'] ?? 'no-data';
    cuerpo = message.data['cuerpo'] ?? 'no-data';
    modulo = message.data['modulo'] ?? 'no-data';

    _mensajesStreamController.sink.add(argumento + "&nbsp" + cuerpo + "&nbsp" + modulo);
  }

  static Future _onOpenHandler(RemoteMessage message) async{
    String argumento = "no-data";
    String cuerpo = "no-data";
    String modulo = "no-data";
    String moduloParams = "no-data";

    if(message != null){
      argumento = message.data['objeto'] ?? 'no-data';
      cuerpo = message.data['cuerpo'] ?? 'no-data';
      modulo = message.data['modulo'] ?? 'no-data';

      _mensajesStreamController.sink.add(argumento + "&nbsp" + cuerpo + "&nbsp" + modulo);
    }
  }

  static Future initialize() async{
    await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.instance.subscribeToTopic("new_releases");    
    if(Platform.isIOS){
      FirebaseMessaging.instance.subscribeToTopic("new_releases_ios");
    }
    else{
      FirebaseMessaging.instance.subscribeToTopic("new_releases_android");
    }
    print(token);

    

    FirebaseMessaging.onBackgroundMessage( _backgroundHandler );
    FirebaseMessaging.onMessage.listen( _onMessageHandler );
    FirebaseMessaging.onMessageOpenedApp.listen( _onOpenHandler );
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );
        print('User push notification status ${ settings.authorizationStatus }');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static closeStreams(){
    _mensajesStreamController?.close();
  }

}
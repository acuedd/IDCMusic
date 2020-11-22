import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Url {
  static const debug = "";
  static const release = "https://idcrom.homelandplanet.com";
  
  
  // About page
  static const String changelog = 'https://raw.githubusercontent.com/acuedd/chuchofChrist/master/CHANGELOG.md';
  static const String authorStore = 'https://play.google.com/store/apps/developer?id=acuedd';
  static const String authorAppStore = "https://apps.apple.com/gt/developer/edward-guillermo-lopez/id1482988460";
  static const String apiContactMe = 'https://api.whatsapp.com/send?phone=50230468139&text=Hola%20me%20interesa%20apoyar%20en%20el%20app&source=&data=';
    static const String playStore = 'https://play.google.com/store/apps/details?id=gt.com.acuedd.church_of_christ';
  static const String appStore = "https://apps.apple.com/gt/app/idc-romanos-16-16/id1482988461";

  static const Map<String, String> authorEmail = {
    'subject': "homeland",
    "address": "eacu@homeland.com.gt",
  };

  static var isDebug = false;

  static getURL(){
    if(Url.isDebug){
      return "${Url.debug}";
    }
    else{
      return "${Url.release}";
    }    
  }
}

class Connection {
  static const Map<String, String> myOperations = {
    "songs": "b6009cea-0500-11eb-b265-0242ac130002",
    "collections": "f0dd5ef2-04f5-11eb-b265-0242ac130002",
  };

  Future con(operation, params) async {
    var myParams = Map<String, String>();
    myParams["o"] = myOperations[operation];
    myParams["f"] = "json";
    myParams["m"] = "am";

    var allParams = {};
    allParams.addAll(myParams);
    allParams.addAll(params);

    try{
      final result = await InternetAddress.lookup("google.com");
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        try{
          print("URL --> ${Url.getURL()}/webservice.php");
          http.Response res = await http.post('${Url.getURL()}/webservice.php', body: allParams).timeout(const Duration(seconds: 30));
          if(res.statusCode == 200){
            var data = jsonDecode(utf8.decode(res.bodyBytes));
            var rest = data as Map<String, dynamic>;
            return rest;
          }
          else{
            return {"valido": 0};
          }
        } 
        on TimeoutException catch(_){
          return {"timeout":"exceeded"};
        }
        catch(e){
          return e;
        }
      }
    }
    on SocketException catch(_){
      return {"interneet":"no"};
    }
  }
  
  // Fetches data & returns it
  Future fetchData(String url, {Map<String, dynamic> parameters}) async {
    final response = await Dio().get(url, queryParameters: parameters);

    return response.data;
  }
}

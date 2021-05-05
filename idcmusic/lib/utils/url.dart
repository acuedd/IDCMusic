import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Url {
  static const debug = "https://idcrom.homelandplanet.com";
  static const release = "https://idcrom.homelandplanet.com";
  
  
  // About page
  static const String changelog = 'https://raw.githubusercontent.com/acuedd/chuchofChrist/master/CHANGELOG.md';
  static const String authorStore = 'https://play.google.com/store/apps/developer?id=acuedd';
  static const String authorAppStore = "https://apps.apple.com/gt/developer/edward-guillermo-lopez/id1482988460";
  static const String apiContactMe = 'https://api.whatsapp.com/send?phone=50230468139&text=Hola%20me%20interesa%20apoyar%20en%20el%20app&source=&data=';
  static const String playStore = 'https://play.google.com/store/apps/details?id=gt.com.acuedd.idcmusic';
  static const String appStore = "https://apps.apple.com/gt/app/acapella-music-idc/id1564129767";

  static const Map<String, String> authorEmail = {
    'subject': "Acapella music app",
    "address": "acuedd@gmail.com",
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


  static const String strAcknoledgementChurch = "A la iglesia de Cristo en Mixco Nueva Jerusalén, Guatemala por su amor y cariño."+
                                          "\n"+
                                          "Romanos 16:16"+
                                          "\n\n"+
                                          "A ti por descargar el app y compartirla con otros, esperando que esta aplicación sea de bendición a cualquier persona que la descargue y escuche alabanzas al Creador."+
                                          "\n";

  static const String strAcknoledgement = "A Dios por su ayuda, providencia y por todas sus bendiciones. "+
                                          "\n\n"+
                                          "A Hno Guillermo Acu y Nancy de Acu por sus ánimos " +
                                          "y confianza para la realización de este proyecto. " +
                                          "\n\n"+
                                          "A las personas que apoyan esta iniciativa."
                                          "\n\n"+
                                          "Romanos 11:35 " +
                                          "\n"+
                                          "Porque de él, y por él, y para él, son todas las cosas. A él sea la gloria por los siglos. Amén."+                                                                                    
                                          "\n";
  static const String thanksToArtist = "Agradecemos a todos los artistas que de buena voluntad han permitido"+
                                        " compartir sus discografías de forma gratuita, si deseas que todo el material"+ 
                                        " futuro siga siendo libre y gratuito, APOYA a tu artista más cercano."+
                                        "\n\n"+
                                        "Si eres artista y te gustaría compartir tu talento, pinchale en \"Apoya la iniciativa\" y contáctame.";

  static const String patreon = "Publicar para iOS y mantener los servidores tienen un costo, si deseas colaborar para que todo siga siendo completamente gratis, pínchale en \"Contáctame.\""+
                                "\n\n" +
                                "Si quieres formar parte del equipo y apoyar con tiempo, mantenimiento o nuevas ideas también pínchale a \"Contáctame\"";
}

class Connection {
  static const Map<String, String> myOperations = {
    "songs": "b6009cea-0500-11eb-b265-0242ac130002",
    "collections": "f0dd5ef2-04f5-11eb-b265-0242ac130002",
  };

  Future connect(operation, params) async {
    var myParams = Map<String, dynamic>();
    myParams["o"] = myOperations[operation];
    myParams["f"] = "json";
    myParams["m"] = "am";

    var allParams = Map<String, dynamic>();
    allParams.addAll(myParams);
    allParams.addAll(params);
    
    debugPrint("URL --> ${Url.getURL()}/webservice.php");
    debugPrint('---api-params----->${allParams}');
    //http.Response res = await http.post('${Url.getURL()}/webservice.php', body: allParams).timeout(const Duration(seconds: 30));
    final response = await Dio().post('${Url.getURL()}/webservice.php', queryParameters: allParams);              
    debugPrint('---api-response----->${response}');
    return response.data;      
  }

  // Fetches data & returns it
  Future fetchData(String url, {Map<dynamic, dynamic> parameters}) async {
    debugPrint("URL --> ${url}");    
    final response = await Dio().get(url, queryParameters: parameters);
    return response.data;
  }
}

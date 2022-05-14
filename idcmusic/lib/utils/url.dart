import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Url {
  static const debug = "https://acaplayer.info";
  static const release = "https://acaplayer.info";
  
  
  // About page
  static const String changelog = 'https://raw.githubusercontent.com/acuedd/IDCMusic/main/idcmusic/CHANGELOG.md';
  static const String authorStore = 'https://play.google.com/store/apps/developer?id=acuedd';
  static const String authorAppStore = "https://apps.apple.com/gt/developer/edward-guillermo-lopez/id1482988460";
  static const String playStore = 'https://play.google.com/store/apps/details?id=gt.com.acuedd.idcmusic';
  static const String appStore = "https://apps.apple.com/gt/app/acapella-music-idc/id1564129767";
  static const String appStoreID = "1564129767";
  static const String apiTelegramChannel = "https://t.me/AcapellaMusicApp";
  static const String apiTelegramGroup = "https://t.me/+0ym98NT24I1mM2Fh";
  static const String apiInstagram = "https://instagram.com/acuedd";

  static const Map<String, String> authorEmail = {
    'subject': "Acapella music app",
    "address": "acuedd@gmail.com",
  };
  static const String appName = "Acapella Music App";

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

  static const String disclaimer = "Esta app es completamente gratuita y no lucramos con el contenido, los derechos de las canciones pertenecen a sus respectivos autores y asociados" +
                "y esta app no pretende adueñarse de ninguno de esos derechos. \nNo almacenamos los archivos de audio de la música en nuestros servidores, la extraemos de lugares donde los creadores la han colocado como pública.\n"+
                "Esta aplicación solamente hace una recopilación de canciones acapella que se encuentran públicas. \n\nSi alguna canción infringe en derechos de autor o no tiene los permisos para compartir, por favor repórtala en nuestro apartado de 'Platiquemos del app' para hacer las gestiones pertinentes y evitar procesos legales";
}

class Connection {
  static const Map<String, String> myOperations = {
    "songs": "b6009cea-0500-11eb-b265-0242ac130002",
    "collections": "f0dd5ef2-04f5-11eb-b265-0242ac130002",
    "registerUser":"75dc1db0-fe28-11eb-b128-e4434b7bc970",
    "authors": "2bcaa998-04f1-11eb-b265-0242ac130002",
    "versionApp": "d9236557-3f5e-11ec-8c0c-0242ac120003",
    "login": "42be2e78-69d3-11e8-84ec-286ed488d291",
    "login_uid": "3d600078-53f0-11ec-980c-0242ac190003",
    "checkUpDateFavoriteList":"583cb499-53d0-11ec-980c-0242ac190003",
    "getAnnotations": "0675d959-57c6-11ec-a43c-0242ac190002",
  };

  Future connect(operation, params, {boolIsJson = false}) async {
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
    var response;
    if(boolIsJson){
      response = await Dio().post('${Url.getURL()}/webservice.php',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }), 
        data: jsonEncode(params)
      );
    }
    else{
      response = await Dio().post('${Url.getURL()}/webservice.php', queryParameters: allParams);              
    }    
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

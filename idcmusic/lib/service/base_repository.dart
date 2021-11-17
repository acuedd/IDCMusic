import 'package:church_of_christ/config/net/base_api.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseRepository{
  
  static Future fetchSongListBase() async {
    var response = await http.post('/', data: {      
      'type': 'netease',
      'filter': 'name',
    });
    return response.data
        .map<Song>((item) => Song.fromJsonMap(item))
        .toList();
  }

  static Future fetchShongList({
    active, nameAuthor, nameTag, nameCollection, idCollection,titleResource,
    lessTime, olderTime, randomSort, limitTo, limitFrom, recently, idAuthor,
  }) async{
    Connection conn = new Connection();

    SharedPreferences prefsApi = await SharedPreferences.getInstance();
    String token = prefsApi.getString('token_user');
    String userid = prefsApi.getString("userloged");

    Map params = Map<String, dynamic>();
    if(token != null && token.isNotEmpty){
      params["t"] = token;
    }
    if(userid != null && userid.toString().isNotEmpty){
      params["allowhidden"] = userid;
    }
    if(nameAuthor != null && nameAuthor.toString().isNotEmpty){
      params["nameAuthor"] = nameAuthor;
    }
    if(nameTag != null && nameTag.toString().isNotEmpty){
      params["nameTag"] = nameTag;
    }
    if(nameCollection != null && nameCollection.toString().isNotEmpty){
      params["nameCollection"] = nameCollection;
    }
    if(idCollection != null && idCollection.toString().isNotEmpty){
      params["idCollection"] = idCollection;
    }
    if(titleResource != null && titleResource.toString().isNotEmpty){
      params["titleResource"] = titleResource;
    }
    if(randomSort != null && randomSort.toString().isNotEmpty){
      params["random_sort"] = randomSort;
    }
    if(limitFrom != null && limitFrom.toString().isNotEmpty){
      params["limit_from"] = limitFrom;
    }
    if(limitTo != null && limitTo.toString().isNotEmpty){
      params["limit_to"] = limitTo;
    }
    if(recently == "Y"){
      params["recently"] = (recently == "Y")?"Y":"N";
    }
    if(idAuthor != null && idAuthor.toString().isNotEmpty){
      params["id_author"] = idAuthor;
    }

    params["active"] = "Y";  

    var response = await conn.connect("songs", params);
    return response;
  }

  static Future fetchAuthors({
    nameAuthor, randomSort, limitTo, limitFrom
  })async{
    Connection conn = new Connection();
    SharedPreferences prefsApi = await SharedPreferences.getInstance();
    String token = prefsApi.getString("token_user");
    String userid = prefsApi.getString("userloged");

    Map params = Map<String, dynamic>();
    if(token != null && token.isNotEmpty){
      params["t"] = token;
    }
    if(nameAuthor != null && nameAuthor.toString().isNotEmpty){
      params["nameCollection"] = nameAuthor;
    }
    if(randomSort != null && randomSort.toString().isNotEmpty){
      params["random_sort"] = randomSort;
    }
    if(limitFrom != null && limitFrom.toString().isNotEmpty){
      params["limit_from"] = limitFrom;
    }
    if(limitTo != null && limitTo.toString().isNotEmpty){
      params["limit_to"] = limitTo;
    }

    var response1 = await conn.connect("authors", params);
    return response1;
  }

  static Future fetchCollections({
    nameAuthor, releaseDate, lowerReleaseDate, nameCollection, randomSort, 
    limitTo, limitFrom
  })async{
    Connection conn = new Connection();
    SharedPreferences prefsApi = await SharedPreferences.getInstance();
    String token = prefsApi.getString("token_user");
    String userid = prefsApi.getString("userloged");

    Map params = Map<String, dynamic>();
    if(token != null && token.isNotEmpty){
      params["t"] = token;
    }
    if(userid != null && userid.toString().isNotEmpty){
      params["allowhidden"] = userid;
    }

    if(nameAuthor != null && nameAuthor.toString().isNotEmpty){
      params["nameAuthor"] = nameAuthor;
    }
    if(releaseDate != null && releaseDate.toString().isNotEmpty){
      params["releaseDate"] = releaseDate;
    }
    if(lowerReleaseDate != null && lowerReleaseDate.toString().isNotEmpty){
      params["lowerReleaseDate"] = lowerReleaseDate;
    }
    if(nameCollection != null && nameCollection.toString().isNotEmpty){
      params["nameCollection"] = nameCollection;
    }
    if(randomSort != null && randomSort.toString().isNotEmpty){
      params["random_sort"] = randomSort;
    }
    if(limitFrom != null && limitFrom.toString().isNotEmpty){
      params["limit_from"] = limitFrom;
    }
    if(limitTo != null && limitTo.toString().isNotEmpty){
      params["limit_to"] = limitTo;
    }
    params["activeCollection"] = "Y";  

    //var response = await conn.con("collections", params);
    var response1 = await conn.connect("collections", params);
    return response1; 
  }  

  static Future<Map<dynamic, dynamic>> fetchChangelog() async{
    Connection conn = new Connection();
    var response = await conn.fetchData(Url.changelog);

    var myresponse = Map<dynamic, dynamic>();
    myresponse["valido"] = 1; 
    myresponse["data"] = response; 
    return myresponse;
  }

  static Future<Map<dynamic, dynamic>> registerUser({
    username, email, firstname, lastname, phone ,token
  }) async{
  
    Connection conn = new Connection();

    Map params = Map<String, dynamic>();
    params["username"] = username;
    params["email"] = email;
    params["firstname"] = firstname;
    params["lastname"] = lastname;    
    if(phone != null)
      params["iPhone"] = phone;
    if(token != null)
      params["activation_token"] = token;

    var response = await conn.connect("registerUser", params);
    return response;
  }

  static Future<Map<dynamic, dynamic>> getLastVersionApp(os, appname, {version}) async{
    Connection conn = new Connection();
    Map params = Map<String, dynamic>();
    params["os"] = os;
    params["app"] = appname;
    if(version != null && version.toString().isNotEmpty){
      params["versionapp"] = version;
    }
    debugPrint("VERSIONAPP ${params}");
    var response = await conn.connect("versionApp", params);
    return response;
  }
}
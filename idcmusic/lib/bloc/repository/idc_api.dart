import 'package:flutter/material.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IDCRepository{
  Connection conn = new Connection();
  SharedPreferences prefs;

  IDCRepository();

  Future fetchChangelog() async{
    return conn.fetchData(Url.changelog);
  }

  Future fetchSongs({
    active, nameAuthor, nameTag, nameCollection, idCollection,titleResource,
    lessTime, olderTime
  }) async{
    SharedPreferences prefsApi = await SharedPreferences.getInstance();
    String token = prefsApi.getString('token_user');

    Map params = {};
    if(token != null && token.isEmpty){
      params["t"] = token;
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

    params["active"] = "Y";  
    return conn.con("songs", params);
  }

  Future fetchCollections({
    nameAuthor, releaseDate, lowerReleaseDate, nameCollection
  }) async{
    SharedPreferences prefsApi = await SharedPreferences.getInstance();
    String token = prefsApi.getString('token_user');

    Map params = {};
    if(token != null && token.isNotEmpty){
      params["t"] = token;
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

    return conn.con("collections", params);

  }
}
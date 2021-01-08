import 'package:church_of_christ/config/net/base_api.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/utils/url.dart';
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
    lessTime, olderTime
  }) async{
    Connection conn = new Connection();

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

    var response = await conn.con("songs", params);
    return response;
  }

  static Future fetchCollections({
    nameAuthor, releaseDate, lowerReleaseDate, nameCollection
  })async{
    Connection conn = new Connection();
    SharedPreferences prefsApi = await SharedPreferences.getInstance();
    String token = prefsApi.getString("token_user");

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

    var response = await conn.con("collections", params);
    return response; 
  }

  static Future<Map<String, dynamic>> fetchChangelog() async{
    Connection conn = new Connection();
    var response = await conn.fetchData(Url.changelog);

    var myresponse = Map<String, dynamic>();
    myresponse["valido"] = 1; 
    myresponse["data"] = response; 
    return myresponse;
  }
}
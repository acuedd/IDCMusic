import 'dart:math';

import 'package:church_of_christ/model/collections_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/view_state_refresh_list_model.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:church_of_christ/utils/url.dart';

class HomeModel extends ViewStateRefreshListModel{
  static const albumValueList = ['酒吧', '怀旧', '女歌手', '经典', '热门'];

  CollectionModel _albums; 
  List<Song> _forYou; 
  CollectionModel get albums => _albums;
  List<Song> get forYou => _forYou; 

  @override
  Future<Map<String, dynamic>> loadData({int pageNum}) async{
    List<Future> futures = []; 

    Random r = new Random();
    int _randomSongAlbum = r.nextInt(albumValueList.length);    
    String inputAlbums = albumValueList[_randomSongAlbum];


    futures.add(BaseRepository.fetchCollections());
    futures.add(BaseRepository.fetchShongList());
    
    //futures.add(BaseRepository.fetchCollections());
    var result = await Future.wait(futures);
    CollectionModel collectionModel = CollectionModel.fromJson(result[0]);  
    _albums = collectionModel;
    List<Song> foryou = convertResponseToListSong(result[1]["resources"]);
    print(foryou);
    _forYou = foryou;
    return result[0];
  }

  List<Song>  convertResponseToListSong(data){
    List<Song> response = [];

    for(var i = 0; i<data.length; i++){

      Map<String,dynamic> mySong = Map<String,dynamic>();
      mySong["type"] = "netease";
      mySong["link"] = "${Url.getURL()}/${data[i]["path"]}";
      mySong["songid"] = data[i]["id_resource"];
      mySong["title"] = data[i]["title_resource"];
      mySong["author"] = data[i]["fullname"];
      mySong["lrc"] = data[i]["duration"];
      mySong["url"] = "${Url.getURL()}/${data[i]["path"]}";
      mySong["pic"] = "${Url.getURL()}/${data[i]["path_image"]}";
      mySong["sourcetype"] = data[i]["sourcetype"];
      mySong["name_collection"] = data[i]["name_collection"];
      mySong["tags"] = data[i]["tags"];
      response.add(Song.fromJsonMap(mySong));
    }

    return response;
  }
}
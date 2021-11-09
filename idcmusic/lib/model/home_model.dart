
import 'package:church_of_christ/model/collections_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/view_state_refresh_list_model.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:church_of_christ/utils/functions.dart';

class HomeModel extends ViewStateRefreshListModel{
  static const albumValueList = [':(', '(TT_TT)', '(TT_TT)', '(TT_TT)', '(TT_TT)'];

  CollectionModel _albums; 
  List<Song> _forYou; 
  List<Song> _songsRecently;
  CollectionModel get albums => _albums;
  List<Song> get forYou => _forYou; 
  List<Song> get songsRecently => _songsRecently;

  @override
  Future<Map<dynamic, dynamic>> loadData({int pageNum}) async{
    List<Future> futures = []; 


    futures.add(BaseRepository.fetchCollections(randomSort: "true", limitFrom: "0", limitTo: "7"));
    futures.add(BaseRepository.fetchShongList(randomSort: "true", limitFrom: "0", limitTo: "10"));
    futures.add(BaseRepository.fetchShongList(randomSort: "true", recently: "Y"));
    
    //futures.add(BaseRepository.fetchCollections());
      var result = await Future.wait(futures);
      Map<dynamic,dynamic> tmpSongRecently = result[2];
      Map<dynamic,dynamic> tmpForYou = result[1];

      _songsRecently = [];
      _forYou = [];

      CollectionModel collectionModel = CollectionModel.fromJson(result[0]);
      _albums = collectionModel;
      
      if(tmpForYou.containsKey("resources")){
        _forYou = convertResponseToListSong(result[1]["resources"]);
      }
    
      if(tmpSongRecently.containsKey("resources")){
        _songsRecently = convertResponseToListSong(result[2]["resources"] ?? []);
      }
      
      return result[2];
  }

}
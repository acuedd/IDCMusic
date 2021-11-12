
import 'package:church_of_christ/model/artist_model.dart';
import 'package:church_of_christ/model/collections_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/view_state_refresh_list_model.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:church_of_christ/utils/functions.dart';

class HomeModel extends ViewStateRefreshListModel{
  static const albumValueList = [':(', '(TT_TT)', '(TT_TT)', '(TT_TT)', '(TT_TT)'];

  CollectionModel _albums; 
  CollectionModel _albums2;
  AuthorModel _authors;
  List<Song> _forYou; 
  List<Song> _songsRecently;
  List<Song> _dailyMix0;
  List<Song> _dailyMix1;
  List<Song> _dailyMix2;

  CollectionModel get albums => _albums;
  CollectionModel get albums2 => _albums2;
  AuthorModel get authors => _authors;
  List<Song> get forYou => _forYou; 
  List<Song> get songsRecently => _songsRecently;
  List<Song> get dailyMix0 => _dailyMix0;
  List<Song> get dailyMix1 => _dailyMix1;
  List<Song> get dailyMix2 => _dailyMix2;

  @override
  Future<Map<dynamic, dynamic>> loadData({int pageNum}) async{
    List<Future> futures = []; 


    futures.add(BaseRepository.fetchCollections(randomSort: "true", limitFrom: "0", limitTo: "7"));
    futures.add(BaseRepository.fetchShongList(randomSort: "true", limitFrom: "0", limitTo: "10"));
    futures.add(BaseRepository.fetchShongList(randomSort: "true", recently: "Y"));
    futures.add(BaseRepository.fetchCollections(randomSort: "true", limitFrom: "0", limitTo: "7"));
    futures.add(BaseRepository.fetchAuthors(randomSort: "true", limitFrom: "0", limitTo: "7"));
    futures.add(BaseRepository.fetchShongList(randomSort: "true", limitFrom: "0", limitTo: "25"));
    futures.add(BaseRepository.fetchShongList(randomSort: "true", limitFrom: "0", limitTo: "50"));
    futures.add(BaseRepository.fetchShongList(randomSort: "true", limitFrom: "0", limitTo: "100"));
    
    //futures.add(BaseRepository.fetchCollections());
      var result = await Future.wait(futures);
      Map<dynamic,dynamic> tmpSongRecently = result[2];
      Map<dynamic,dynamic> tmpForYou = result[1];
      Map<dynamic,dynamic> tmpDailyMix0 = result[5];
      Map<dynamic,dynamic> tmpDailyMix1 = result[6];
      Map<dynamic,dynamic> tmpDailyMix2 = result[7];

      _songsRecently = [];
      _forYou = [];

      CollectionModel collectionModel = CollectionModel.fromJson(result[0]);
      _albums = collectionModel;
      CollectionModel collectionModel2 = CollectionModel.fromJson(result[3]);
      _albums2 = collectionModel2;

      AuthorModel authorsModel = AuthorModel.fromJson(result[4]);
      _authors = authorsModel;
      
      if(tmpForYou.containsKey("resources")){
        _forYou = convertResponseToListSong(result[1]["resources"]);
      }
      if(tmpDailyMix0.containsKey("resources")){
        _dailyMix0 = convertResponseToListSong(result[5]["resources"]);
      }
      if(tmpDailyMix1.containsKey("resources")){
        _dailyMix1 = convertResponseToListSong(result[6]["resources"]);
      }
      if(tmpDailyMix2.containsKey("resources")){
        _dailyMix2 = convertResponseToListSong(result[7]["resources"]);
      }
    
      if(tmpSongRecently.containsKey("resources")){
        _songsRecently = convertResponseToListSong(result[2]["resources"] ?? []);
      }
      
      return result[2];
  }

}
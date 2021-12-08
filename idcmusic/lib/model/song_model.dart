import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/provider/view_state_refresh_list_model.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumListModel extends ViewStateRefreshListModel<Song>{
  final String input; 

  AlbumListModel({this.input}); 

  @override
  Future<Map<dynamic,dynamic >> loadData({int pageNum}) async{
    return await BaseRepository.fetchShongList(idCollection:input );
  }
}

class AuthorsListModel extends ViewStateRefreshListModel<Song>{
  final String input;

  AuthorsListModel({this.input});

  @override
  Future<Map<dynamic,dynamic>> loadData({int pageNum}) async{
    
    return await BaseRepository.fetchShongList(idAuthor: input);
  }
}

class SongListModel extends ViewStateRefreshListModel<Song>{ 
  final String input;
  final bool recently; 

  SongListModel({this.input, this.recently = false}); 

  @override
  Future<Map<dynamic, dynamic>> loadData({int pageNum}) async{
    return await BaseRepository.fetchShongList(titleResource: input, recently: (recently)?"Y":"N");
  }
}

class SongModel with ChangeNotifier{ 
  String _url; 
  String get url => _url; 
  setUrl(String url){
    _url = url; 
    notifyListeners();
  }

  AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId("acapella_music"); 
  AssetsAudioPlayer get audioPlayer => _audioPlayer; 

  List<Song> _songs; 
  List<Audio> _songsAudio;

  bool _isPlaying = false; 
  bool get isPlaying => _isPlaying; 
  setPlaying(bool isPlaying){
    _isPlaying = isPlaying; 
    //notifyListeners();
  }

  LoopMode _loopMode = LoopMode.none;
  bool _isShuffle = false;
  LoopMode get loopMode => _loopMode; 
  bool get isShuffle => _isShuffle;
  setLoopMode(LoopMode mode){
    _loopMode = mode;
    notifyListeners();
  }
  changeRepeat(){
    _audioPlayer.toggleLoop();
    notifyListeners();
  }
  changeSuffle(){
    _isShuffle = !_isShuffle;
    /*_audioPlayer.toggleShuffle();
    List<Song> newListSong = [];
    _audioPlayer.playlist.audios.forEach((Audio element) {
      
      newListSong.add(new Song(
        type: element.metas.extra["type"],
        link: element.metas.extra["link"],
        songid: element.metas.extra["songid"],
        title: element.metas.extra["title"],
        author: element.metas.extra["author"],
        lrc: element.metas.extra["lrc"],
        url: element.metas.extra["url"],
        pic: element.metas.extra["pic"],
        ext: element.metas.extra["ext"],
      ));
    });
    _songs = newListSong;*/
    notifyListeners();
  }

  bool _showList = false; 
  bool get showList => _showList; 
  setShowList(bool showList){
    _showList = showList;
    notifyListeners(); 
  }

  int _currentSongIndex = 0; 
  int _nextSongIndex = 0;
  int _previousSongIndex = 0;

  List<Song> get songs => _songs; 
  List<Audio> get songsAudio => _songsAudio;
  
  setSongs(List<Song> songs, BuildContext context){
    DownloadModel downloadModel = Provider.of(context, listen: false);
    _songs = songs; 
    _songsAudio = convertListToAudioList(songs, downloadModel);
    //print(_songsAudio);
    notifyListeners();
  }

  addSongs(List<Song> songs, BuildContext context){
    DownloadModel downloadModel = Provider.of(context);
    _songs.addAll(songs);
    _songsAudio.addAll(convertListToAudioList(songs, downloadModel));
    notifyListeners();
  }  

  convertListToAudioList(List<Song> songs, downloadModel){
    List<Audio> mySongAudio = [];
    
    for(var i = 0; i < songs.length; i++){
      Song item = songs[i];
      String url;
      Audio audio;    
      if (downloadModel.isDownload(item)) {
        Map <String, dynamic> extras = new Map<String,dynamic>();
        extras["author"] = item.author;
        extras["ext"] = item.ext;
        extras["link"] = item.link;
        extras["lrc"] = item.lrc;
        extras["name_collection"] = item.name_collection;
        extras["pic"] = item.pic;
        extras["songid"] = item.songid;
        extras["sourcetype"] = item.sourcetype;
        extras["tags"] = item.tags;
        extras["title"] = item.title;
        extras["type"] = item.type;
        extras["url"] = item.url;


        url = downloadModel.getDirectoryPath + '/${item.songid}';
        audio = Audio.file(
            url, 
            metas: Metas(
                id: item.songid, 
                title: item.title, 
                artist: item.author, 
                album: item.name_collection, 
                //image: MetasImage.network(path)
                extra: extras,
            )
          );
      }
      else{
        Map <String, dynamic> extras = new Map<String,dynamic>();
        extras["author"] = item.author;
        extras["ext"] = item.ext;
        extras["link"] = item.link;
        extras["lrc"] = item.lrc;
        extras["name_collection"] = item.name_collection;
        extras["pic"] = item.pic;
        extras["songid"] = item.songid;
        extras["sourcetype"] = item.sourcetype;
        extras["tags"] = item.tags;
        extras["title"] = item.title;
        extras["type"] = item.type;
        extras["url"] = item.url;

        url = item.url;
        audio = Audio.network(
          url, 
          metas: Metas(
              id: item.songid,  
              title: item.title, 
              artist: item.author, 
              album: item.name_collection,
              image: MetasImage.network(item.pic),
              extra: extras,
          )
        );
      }
      mySongAudio.add(audio);
    }
    return mySongAudio;
  }

  int get length => _songs.length; 
  int get songNumber => _currentSongIndex +1;

  setCurrentIndex(int index){
    _currentSongIndex = index; 
    notifyListeners();
  }

  setNextIndex(int index){
    _nextSongIndex = index;
    notifyListeners();
  }

  setPreviousIndex(int index){
    _previousSongIndex = index;
    notifyListeners();
  }

  bool _playNow = false;
  bool get playNow => _playNow;
  setPlayNow(bool playNow){
    _playNow = playNow;
    //notifyListeners();
  }

  Song get currentSong => _songs[_currentSongIndex];    
  int get currentSongIndex => _currentSongIndex;
  int get nextSongIndex => _nextSongIndex;
  int get prevSongIndex => _previousSongIndex;

  int get randomIndex{
    Random r = new Random();
    return r.nextInt(_songs.length);
  }

  Duration _position; 
  Duration get position => _position;
  void setPosition(Duration position){
    _position = position;
    notifyListeners();
  }

  Duration _duration; 
  Duration get duration => _duration;
  void setDuration(Duration duration){
    _duration = duration; 
    notifyListeners();
  }

  void playNowIndex(){
    _audioPlayer.playlistPlayAtIndex(_currentSongIndex);
  }

  bool changeSomething;
  void setBoolChangeSomething(bool changed){
    changeSomething = changed;
    notifyListeners();
  }
}

class Song {
  String type;
  String link;
  dynamic songid;
  String title;
  String author;
  String lrc;
  String url;
  String pic;
  String ext;
  String annotation1;
  String annotation2;

  // ignore: non_constant_identifier_names
  dynamic name_collection;
  dynamic sourcetype;
  List<Tag> tags;

  Song({this.type, this.link, this.songid, this.title, this.author, this.lrc, this.url, this.pic, this.ext});

  Song.fromJsonMap(Map<dynamic, dynamic> map)
      : type = map["type"],
        link = map["link"],
        songid = map["songid"],
        title = map["title"],
        author = map["author"],
        lrc = map["lrc"],
        url = map["url"],
        pic = map["pic"],
        ext = map["ext"],
        annotation1 = map["has_annotation1"], 
        annotation2 = map["has_annotation2"],
        name_collection = map["name_collection"], 
        sourcetype = map["sourcetype"];
        //tags = List<Tag>.from(map["tags"] ?? [].map((x) => Tag.fromJson(x)));

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['type'] = type;
    data['link'] = link;
    data['songid'] = songid;
    data['title'] = title;
    data['author'] = author;
    data['lrc'] = lrc;
    data['url'] = url;
    data['pic'] = pic;
    data["ext"] = ext;
    data["has_annotation1"] = annotation1 ; 
    data["has_annotation2"] = annotation2;
    data["name_collection"] = name_collection;
    data["sourcetype"] = sourcetype;
    return data;
  }
}

class Tag{
  dynamic id_tag;
  dynamic name_tag;

  Tag({
    this.id_tag, 
    this.name_tag,
  });

  factory Tag.fromJson(Map<dynamic, dynamic> json) => Tag(
    id_tag: json["id_tag"], 
    name_tag: json["name_tag"],
  );

}
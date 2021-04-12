import 'dart:io';

import 'package:church_of_christ/config/storage_manager.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/view_state_list_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

const String kLocalStorageSearch = 'kLocalStorageSearch';
const String kDownloadList = 'kDownloadList';
const String kDirectoryPath = 'kDirectoryPath';

class DownloadListModel extends ViewStateListModel<Song>{
  DownloadModel downloadModel;

  DownloadListModel({this.downloadModel});

  @override
  Future<Map<String, dynamic>> loadData() async{
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready; 
    
    List<Song> downloadList = (localStorage.getItem(kDownloadList) ?? []).map<Song>((item){
      Map<String,dynamic> mySong = Map<String,dynamic>();      
      return Song.fromJsonMap(item);
    }).toList();
    downloadModel.setDownloads(downloadList); 
    setIdle(); 

    var downloadreturn = Map<String, dynamic>();
    downloadreturn["valido"] = 1;
    downloadreturn["detalle"] = downloadList;
    return downloadreturn;
  }
}

class DownloadModel with ChangeNotifier{
  DownloadModel(){
    _directoryPath = StorageManager.sharedPreferences.getString(kDirectoryPath);
  }
  List<Song> _downloadSong;
  List<Song> get downloadSong => _downloadSong;

  setDownloads(List<Song> downloadSong){
    _downloadSong = downloadSong;
    notifyListeners();
  } 

  download(Song song){
    if(_downloadSong.contains(song)){
      removeFile(song);
    }
    else{
      downloadFile(song);
    }
  }

  String getSongUrl(Song s){
    return s.url;
  }

  Future downloadFile(Song s) async{
    final bytes = await readBytes(getSongUrl(s));
    final dir = await getApplicationDocumentsDirectory();
    setDirectoryPath(dir.path);
    final file = File('${dir.path}/${s.songid}.${s.ext}');

    if(await file.exists()){
      return; 
    }

    await file.writeAsBytes(bytes);
    if(await file.exists()){
      _downloadSong.add(s);
      saveData();
      notifyListeners();
    }
  }

  String _directoryPath; 
  String get getDirectoryPath => _directoryPath;
  setDirectoryPath(String directoryPath){
    _directoryPath = directoryPath; 
    StorageManager.sharedPreferences.setString(kDirectoryPath, _directoryPath);
  }

  Future removeFile(Song s) async{
    final dir = await getApplicationDocumentsDirectory(); 
    final file = File('${dir.path}/${s.songid}.mp3');
    setDirectoryPath(dir.path); 
    if(await file.exists()){
      await file.delete();
      _downloadSong.remove(s);
      saveData(); 
      notifyListeners();
    }
  }

  saveData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    localStorage.setItem(kDownloadList, _downloadSong);
  }

  isDownload(Song newSong){
    bool isDownload = false; 
    for(int i =0; i < _downloadSong.length; i++){
      if(_downloadSong[i].songid == newSong.songid){
        isDownload = true;
        break;
      }
    }
    return isDownload;
  }
}
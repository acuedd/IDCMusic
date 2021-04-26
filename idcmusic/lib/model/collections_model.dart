import 'package:church_of_christ/provider/view_state_refresh_list_model.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:church_of_christ/utils/url.dart';

class AlbumModel extends ViewStateRefreshListModel<CollectionModel>{
  final String input; 

  AlbumModel({this.input}); 

  @override
  Future<Map<dynamic,dynamic >> loadData({int pageNum}) async{
    return await BaseRepository.fetchCollections();
  }
}


class CollectionModel {
  List<Collection> collections;

  CollectionModel({
    this.collections,
  });

  factory CollectionModel.fromJson(Map json) {
    var myDetail = json["detailCollections"] ?? [];
    return CollectionModel(
      collections: List<Collection>.from(myDetail.map((x) => Collection.fromJson(x))),
    );
  } 

  factory CollectionModel.fromJsonCollection(Map json) {
    return CollectionModel(
      collections: List<Collection>.from(json["resources"].map((x) => Collection.fromJson(x))),
    );
  } 
}

class Collection{
  dynamic id;
  String name_collection;
  String release_date;
  dynamic id_Autor;
  String path_image;
  String fullname;

  Collection({
    this.id, 
    this.name_collection, 
    this.release_date, 
    this.id_Autor, 
    this.path_image, 
    this.fullname,
  });

  factory Collection.fromJson(Map<dynamic, dynamic> json) => Collection(
    id: json["id"],
    name_collection: json["name_collection"], 
    release_date: json["release_date"], 
    id_Autor: json["id_Autor"], 
    path_image: "${Url.getURL()}/${json["path_image"]}", 
    fullname: json["fullname"],
  );
}
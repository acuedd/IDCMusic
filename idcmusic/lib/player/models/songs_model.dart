import 'package:church_of_christ/player/models/AudioPlayerModel.dart';
import 'package:church_of_christ/utils/url.dart';

class SongModel{
  List<Song> songs;
  SongModel({
    this.songs,
  });

  factory SongModel.fromJson(Map<dynamic, dynamic> json) => SongModel(
    songs: List<Song>.from(json["resources"].map((x) => Song.fromJson(x))),
  );
}


class Song{
  String fullname;
  String name_collection;
  String title_resource;
  String path;
  dynamic duration;
  dynamic id_resource;
  String sourcetype;
  dynamic id_collection;
  dynamic active;
  dynamic path_image;
  List<Tag> tags;

  Song({
    this.fullname,
    this.name_collection, 
    this.title_resource, 
    this.path, 
    this.duration, 
    this.id_resource, 
    this.sourcetype, 
    this.id_collection, 
    this.active,
    this.path_image,
    this.tags,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
    fullname: json["fullname"], 
    name_collection: json["name_collection"], 
    title_resource: json["title_resource"], 
    path: '${Url.getURL()}/${json["path"]}', 
    duration: json["duration"], 
    id_resource: json["id_resource"], 
    sourcetype: json["sourcetype"], 
    id_collection: json["id_collection"], 
    active: json["active"],
    path_image: '${Url.getURL()}/${json["path_image"]}',
    tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
  );
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
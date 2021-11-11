import 'package:church_of_christ/provider/view_state_refresh_list_model.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:church_of_christ/utils/url.dart';

class ArtistModel extends ViewStateRefreshListModel<AuthorModel>{
  final String input;

  ArtistModel({this.input});

  @override
  Future<Map<dynamic,dynamic >> loadData({int pageNum}) async{
    return await BaseRepository.fetchAuthors();
  }
}

class AuthorModel{
  List<Author> authors;

  AuthorModel({
    this.authors
  });

  factory AuthorModel.fromJson(Map json){
    var myDetail = json["detailAuthors"] ?? [];
    return AuthorModel(
      authors: List<Author>.from(myDetail.map( (x)=> Author.fromJson(x))),
    );
  }

  factory AuthorModel.fromJsonCollection(Map json) {
    return AuthorModel(
      authors: List<Author>.from(json["resources"].map((x) => Author.fromJson(x))),
    );
  }
}

class Author{
  dynamic id;
  dynamic nickname;
  dynamic fullname;
  dynamic firstname;
  dynamic lastname;
  String path_image;
  dynamic biography_author;
  
  Author({
    this.id, 
    this.nickname, 
    this.fullname, 
    this.firstname, 
    this.lastname, 
    this.path_image, 
    this.biography_author
  });

  factory Author.fromJson(Map<dynamic, dynamic> json) => Author(
    id: json["id"],
    nickname: json["nickname"],
    fullname: json["fullname"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    path_image: "${Url.getURL()}/${json["path_image"]}",
    biography_author: json["biography_author"],
  );
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/model/collections_model.dart';
import 'package:church_of_christ/ui/page/album_page.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class itemCollection extends StatelessWidget{
  final Collection album;
  final int index;
  final int length;
  
  const itemCollection({Key key, @required this.album, this.index, this.length}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenAspectRatio = 0;
    if(screenHeight>800){
      screenAspectRatio = 150.0;
    }
    else if(screenHeight>=600 && screenHeight <= 800){
      screenAspectRatio = 145.0;
    }
    else if(screenHeight <= 600){
      screenAspectRatio = 140.0;
    }

    imageAlbum albumImage = imageAlbum(album.path_image, screenAspectRatio);
    
    return GestureDetector(
      onTap: () => {
        Navigator.push(context, SlideLeftRouteBuilder(AlbumsPage(album, image: albumImage,)))
      },
      child: Container(
        width: 140,
        margin: index == length -1
          ? EdgeInsets.only(right: 20.0)
          : EdgeInsets.only(right: 0.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0,),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: albumImage,
              ),
              SizedBox(height: 3,),
              Text(
                album.name_collection,
                textAlign: TextAlign.center,
                style: GetTextStyle.M(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0,),
              Text(
                album.fullname,
                textAlign: TextAlign.center,
                style: GetTextStyle.SM(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );

  }
}

class imageAlbum extends StatelessWidget{

  final String path;
  final double screenAspectRatio;

  imageAlbum(this.path, this.screenAspectRatio);

  @override
  Widget build(BuildContext context) {
    return Image(
            height: screenAspectRatio,
            width: screenAspectRatio,
            image: CachedNetworkImageProvider(path),
            fit: BoxFit.cover,
          );
  }
  
}
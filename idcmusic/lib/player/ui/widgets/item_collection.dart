import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/player/models/collections_model.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class itemCollection extends StatelessWidget{
  final Collection album;
  final int index;
  final int length;
  
  const itemCollection({Key key, @required this.album, this.index, this.length}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        //TODO go to albumpage
      },
      child: Container(
        width: 140,
        margin: index == length -1
          ? EdgeInsets.only(right: 20.0)
          : EdgeInsets.only(right: 0.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  height: 120.0,
                  width: 120.0,
                  image: CachedNetworkImageProvider(album.path_image),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                album.name_collection,
                textAlign: TextAlign.center,
                style: GetTextStyle.SM(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10,),
              Text(
                album.fullname,
                textAlign: TextAlign.center,
                style: GetTextStyle.SS(context),
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
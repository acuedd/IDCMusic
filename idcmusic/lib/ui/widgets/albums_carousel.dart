

import 'package:church_of_christ/config/routes.dart';
import 'package:church_of_christ/model/collections_model.dart';
import 'package:church_of_christ/ui/widgets/item_collection.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class AlbumsCarousel extends StatefulWidget {
  final List<Collection> albums;

  AlbumsCarousel(this.albums);

  _AlbumsCarouselState createState() => _AlbumsCarouselState();
}

class _AlbumsCarouselState extends State<AlbumsCarousel>{
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding( 
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Albums",
              style: GetTextStyle.XL(context),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed(RouteName.allCollections);
              },
              child: Text("Ver todos",
                style: GetTextStyle.M(context),
              ),
            )
          ],
        ),
      ), 
      Column(
        children: <Widget>[
          Container(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.albums.length,
              itemBuilder: (BuildContext context, int index){
                Collection album = widget.albums[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: itemCollection(album: album, index: index, length: widget.albums.length,),
                );
              },
            ),
          ),
        ],
      ),
    ]);
  }
}
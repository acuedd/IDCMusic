import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/player/models/collections_model.dart';
import 'package:church_of_christ/player/ui/widgets/item_collection.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:church_of_christ/utils/routes.dart';
import 'package:flutter/material.dart';


class AlbumsCarousel extends StatefulWidget {
  final List<Collection> alubums;

  AlbumsCarousel(this.alubums);
  @override
  _AlbumsCarouselState createState() => _AlbumsCarouselState();

}

class _AlbumsCarouselState extends State<AlbumsCarousel> {
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
                style: GetTextStyle.SM(context),
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
              itemCount: widget.alubums.length,
              itemBuilder: (BuildContext context, int index){
                Collection album = widget.alubums[index];
                return itemCollection(album: album, index: index, length: widget.alubums.length,);
              },
            ),
          ),
        ],
      )
    ],);
  }
}
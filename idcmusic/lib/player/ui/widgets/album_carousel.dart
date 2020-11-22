import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/player/models/collections_model.dart';
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
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2
              ),
            ),
            GestureDetector(
              onTap: ()=>{
                print("View all"),
              },
              child: Text("Ver todos",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold
                ),
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
                return GestureDetector(
                  onTap: () => {
                    //TODO go to albumpage
                  },
                  child: Container(
                    width: 140,
                    margin: index == widget.alubums.length -1
                      ? EdgeInsets.only(right: 20.0)
                      : EdgeInsets.only(right: 0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10,),
                          Text(
                            album.fullname,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
    ],);
  }
}
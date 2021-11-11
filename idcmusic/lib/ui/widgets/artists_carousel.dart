import 'package:church_of_christ/config/routes.dart';
import 'package:church_of_christ/model/artist_model.dart';
import 'package:church_of_christ/ui/widgets/item_author.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class ArtistsCarousel extends StatefulWidget{
  final List<Author> authors; 
  final bool showSeeAll; 

  ArtistsCarousel(this.authors, {this.showSeeAll = true});

  _ArtistsCarouselState createState() => _ArtistsCarouselState();
}

class _ArtistsCarouselState extends State<ArtistsCarousel>{

  @override
  Widget build(BuildContext context) {
    return (widget.authors!= null) 
    ?Column(children: <Widget>[
      if(widget.showSeeAll)
      Padding( 
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Artistas",
              style: GetTextStyle.XL(context),
            ),
            GestureDetector(
              onTap: (){              
                Navigator.of(context).pushNamed(RouteName.allArtists);
              },
              child: Text("Ver todos",
                style: GetTextStyle.M(context),
              ),
            )
          ],
        ),
      ),
      Container(
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.authors.length,
          itemBuilder: (BuildContext context, int index){
            Author myAuthor = widget.authors[index];
            return Padding(  
              padding: const EdgeInsets.only(left: 8.0),
              child: itemAuthor(author: myAuthor, index: index, length: widget.authors.length,)
            );
          }
        ),
      ),
    ])
    : Container();
  }
}
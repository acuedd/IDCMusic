
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/config/routes.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:church_of_christ/ui/page/songs_all_page.dart';
import 'package:church_of_christ/ui/widgets/songItem.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForYouCarousel extends StatefulWidget{
  final List<Song> forYou; 

  ForYouCarousel(this.forYou); 
  @override
  _ForYouCarouselState createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<ForYouCarousel>{

  @override
  Widget build(BuildContext context) {
    return Column( 
      children: <Widget>[
        Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Para ti",
                style: GetTextStyle.XL(context),
              ),
              GestureDetector( 
                onTap: (){
                  Navigator.push(context, 
                  SlideBottomRouteBuilder(SongsAllCarousel()));
                },
                child: Text("Ver todas",
                  style: GetTextStyle.M(context),
                ),
              )
            ],
          ),
        ),
        ListView.builder( 
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: widget.forYou.length,
          itemBuilder: (BuildContext context, int index){
            Song data = widget.forYou[index];
            return SongItem(song: data, songs: new List<Song>.from(widget.forYou),index: index,);
          },
        )
      ],
    );
  }
  
}
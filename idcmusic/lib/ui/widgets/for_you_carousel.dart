import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/songs_all_page.dart';
import 'package:church_of_christ/ui/widgets/songItem.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class ForYouCarousel extends StatefulWidget{
  final List<Song> forYou; 

  ForYouCarousel(this.forYou); 
  @override
  _ForYouCarouselState createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<ForYouCarousel>{

  @override
  Widget build(BuildContext context) {
    final int intLimitShowRecently = 5;
    return Column( 
      children: <Widget>[
        Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
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
          itemCount: intLimitShowRecently,
          itemBuilder: (BuildContext context, int index){
            Song data = widget.forYou[index];
            return SongItem(song: data, songs: new List<Song>.from(widget.forYou),index: index,);
          },
        )
      ],
    );
  }
  
}
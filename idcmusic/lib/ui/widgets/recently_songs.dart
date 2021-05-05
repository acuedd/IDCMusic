
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

class RecentlySongs extends StatefulWidget{
  final List<Song> songs;

  RecentlySongs(this.songs);

  @override
  _RecentlySongsState createState() => _RecentlySongsState();
}

class _RecentlySongsState extends State<RecentlySongs>{
  

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
              Text("Lo más reciente",
                style: GetTextStyle.XL(context),
              ),
              GestureDetector( 
                onTap: (){
                  Navigator.push(context, 
                  SlideBottomRouteBuilder(SongsAllCarousel(recently: true,strTitle: "Lo más reciente",)));
                },
                child: Text("Ver todos",
                  style: GetTextStyle.M(context),
                ),
              )
        ]),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.songs.length,
        itemBuilder: (BuildContext context, int index){
          Song data = widget.songs[index];
          return GestureDetector( 
              onTap: (){
                if(null != data.url){
                  SongModel songModel = Provider.of(context, listen: false);
                  songModel.setSongs(new List<Song>.from(widget.songs), context);
                  songModel.setCurrentIndex(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayPage(
                        nowPlay: true,
                      ),
                    ),
                  );
                }
              },
              child: SongItem(song: data),
            );
        },
      ),
    ]);
  }
}
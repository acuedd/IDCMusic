
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
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

  Widget _buildSongItem(Song data){
    FavoriteModel favoriteModel = Provider.of(context);
    
    return Padding( 
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row( 
        children: <Widget>[
          Stack( 
            children: <Widget>[
              Container( 
                height: 50.0,
                width: 50.0,
                child: ClipRRect( 
                  borderRadius: BorderRadius.circular(12.0),
                  child: Utils.image(data.pic, fit: BoxFit.cover)
                ),
              ), 
              Container( 
                height: 50.0,
                width: 50.0,
                child: Icon( 
                  Icons.play_circle_filled, 
                  color: Colors.white.withOpacity(0.7),
                  size: 42.0,
                ),
              ),
            ],
          ),
          SizedBox(width: 20.0,), 
          Expanded( 
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( 
                  data.title, 
                  style: GetTextStyle.M(context),
                ), 
                SizedBox(height: 8.0,),
                Text( 
                  data.author, 
                  style: GetTextStyle.S(context),
                )
              ],
            ),
          ), 
          IconButton(
            onPressed: () => favoriteModel.collect(data),
            icon: data.url == null
                  ? Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 20.0,
                    )
                  : favoriteModel.isCollect(data)
                      ? Icon(
                          Icons.favorite,
                          color: Theme.of(context).accentColor,
                          size: 20.0,
                        )
                      : Icon(
                          Icons.favorite_border,
                          size: 20.0,
                        ),
          ),
        ],
      ),
    );
  }

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
                onTap: ()=>{
                  print("View all"),
                },
                child: Text("Ver todos",
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
            return GestureDetector( 
              onTap: (){
                if(null != data.url){
                  SongModel songModel = Provider.of(context, listen: false);
                  songModel.setSongs(new List<Song>.from(widget.forYou));
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
              child: _buildSongItem(data),
            );
          },
        )
      ],
    );
  }
  
}
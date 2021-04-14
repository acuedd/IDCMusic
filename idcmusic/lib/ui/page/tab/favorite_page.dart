import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin {
    
  @override
  bool get wantKeepAlive => true;

  Widget _buildSongItem(Song data){
    FavoriteModel  favoriteModel = Provider.of(context);
    return Padding( 
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row( 
        children: <Widget>[
          ClipRRect( 
            borderRadius: BorderRadius.circular(12.0),
            child: Container( 
              width: 50,
              height: 50,
              child: Image( image: CachedNetworkImageProvider(data.pic),),
            ),
          ), 
          SizedBox(width: 20.0,), 
          Expanded( 
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    data.title,
                    style: data.url == null
                        ? TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE0E0E0),
                          )
                        : TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox( height: 10,), 
                  Text( 
                    data.author, 
                    style: data.url == null 
                      ? TextStyle(
                        fontSize: 10.0, 
                        color: Color(0xFFE0E0E0), 
                      )
                      : TextStyle(
                        fontSize: 10.0, 
                        color: Colors.grey, 
                      ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ), 
          IconButton(
            icon: data.url == null
                  ? Icon(
                      Icons.favorite_border,
                      color: Color(0xFFE0E0E0),
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
            onPressed: () => favoriteModel.collect(data),            
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    FavoriteModel favoriteModel = Provider.of(context);
    return Scaffold( 
      body: SafeArea( 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding( 
              padding: const EdgeInsets.all(20.0),
              child: Text("Favoritas",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2
                ),
              ),
            ), 
            Expanded( 
              child: favoriteModel.favoriteSong.length == 0 
                ? Center(
                    child: EmptyListWidget(
                      image : null,
                      packageImage: PackageImage.Image_4,
                      title: 'No tienes favoritas',
                      subTitle: 'Aún no agregas tu\n canciones favoritas',
                      titleTextStyle: Theme.of(context).typography.dense.headline4.copyWith(color: Color(0xff9da9c7)),
                      subtitleTextStyle: Theme.of(context).typography.dense.bodyText1.copyWith(color: Color(0xffabb8d6))
                    ),
                  ) 
                : ListView.builder(
                    itemCount: favoriteModel.favoriteSong.length,
                    itemBuilder: (BuildContext context, int index){
                      Song data = favoriteModel.favoriteSong[index]; 
                      return GestureDetector( 
                        onTap: (){
                          if(null != data.url){
                            SongModel songModel = Provider.of(context, listen: false);
                            songModel.setSongs(new List<Song>.from(favoriteModel.favoriteSong));
                            songModel.setCurrentIndex(index);
                            Navigator.push(context, 
                              MaterialPageRoute(
                                builder: (_) => PlayPage(
                                  nowPlay: true,
                                )
                              ), 
                            );
                          }
                        },
                        child: _buildSongItem(data),
                      );
                    }
                  ),
            )
          ],
        ),
      )
    );
  }
}
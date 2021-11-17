import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/service/authenticate.dart';
import 'package:church_of_christ/ui/page/user_library.dart';
import 'package:church_of_christ/ui/widgets/empty_widget.dart';
import 'package:church_of_christ/ui/widgets/player_widget.dart';
import 'package:church_of_christ/ui/widgets/songItem.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:church_of_christ/utils/anims/record_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget{
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with TickerProviderStateMixin , AutomaticKeepAliveClientMixin{
    
  AnimationController controllerRecord; 
  Animation<double> animationRecord; 
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0); 
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    
    controllerRecord = new AnimationController(
       duration: const Duration(milliseconds: 15000), vsync: this);
     animationRecord = new CurvedAnimation(parent: controllerRecord, curve: Curves.linear);
     animationRecord.addStatusListener((status) {
       if(status == AnimationStatus.completed){
         controllerRecord.repeat();
       }
       else if(status == AnimationStatus.dismissed ){
         controllerRecord.forward();
       }
     });
     
  }

  @override
  void dispose() {
    controllerRecord.dispose();
    super.dispose();    
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    DownloadModel downloadModel = Provider.of(context);
    SongModel songModel = Provider.of(context);
    Authentication auth = Provider.of(context);

    if(songModel.isPlaying){
      controllerRecord.forward();
    }
    else {
      controllerRecord.stop(canceled: false);
    }
    
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
            if(!Platform.isIOS)           
            Consumer(
            // ignore: missing_return
            builder: (context, Authentication user, _) {
              switch (user.status){
                case Status.Authenticated: 
                  return UserLibrary(login: true,);
                case Status.Authenticating: 
                  return loadingIndicator();
                  break;
                case Status.Unauthenticated:
                  return UserLibrary(login: false,);
                  break;
                case Status.Uninitialized:
                  return loadingIndicator();
                  break;
              }
            }),
            Expanded( 
              child: favoriteModel.favoriteSong.length == 0 
                ? Center(
                    child: EmptyWidget(
                      title: 'No tienes favoritas',
                      description: 'Aún no agregas tu\n canciones favoritas',
                    ),
                  ) 
                : ListView.builder(
                    itemCount: favoriteModel.favoriteSong.length,
                    itemBuilder: (BuildContext context, int index){
                      Song data = favoriteModel.favoriteSong[index]; 
                      return SongItem(song: data, songs: new List<Song>.from(favoriteModel.favoriteSong), index: index);
                    }
                  ),
            )
          ],
        ),
      ), 
      bottomNavigationBar: BottomAppBar( 
        child: PlayerWidget(songModel),
      ),
    );
  }
}
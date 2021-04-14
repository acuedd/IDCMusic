
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/player_carousel.dart';
import 'package:church_of_christ/ui/widgets/song_list_carrousel.dart';
import 'package:church_of_christ/utils/anims/player_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayPage extends StatefulWidget{
   final bool nowPlay; 

   PlayPage({this.nowPlay});

   @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin{
  AnimationController controllerPlayer; 
  Animation<double> animationPlayer; 
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  void initState() {
    super.initState();
    controllerPlayer = new AnimationController( duration: const Duration(milliseconds: 15000), vsync: this);
    animationPlayer = new CurvedAnimation(parent: controllerPlayer, curve: Curves.linear);
    animationPlayer.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        controllerPlayer.repeat();
      }
      else if(status == AnimationStatus.dismissed){
        controllerPlayer.forward();
      }
    });
  }

  @override
  void dispose() {
    controllerPlayer.dispose();
    super.dispose();
  }

  String getSongUrl(Song s){
    return s.url;
  }

   @override
  Widget build(BuildContext context) {
    SongModel songModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);
    FavoriteModel favouriteModel = Provider.of(context);
    if (songModel.isPlaying) {
      controllerPlayer.forward();
    } else {
      controllerPlayer.stop(canceled: false);
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  !songModel.showList
                      ? Column(
                          children: <Widget>[
                            AppBarCarrousel(title: "",),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            RotatePlayer(
                                animation:
                                    _commonTween.animate(controllerPlayer)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () => songModel
                                        .setShowList(!songModel.showList),
                                    icon: Icon(
                                      Icons.list,
                                      size: 25.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => songModel.changeRepeat(),
                                    icon: songModel.isRepeat == true
                                        ? Icon(
                                            Icons.repeat,
                                            size: 25.0,
                                            color: Colors.grey,
                                          )
                                        : Icon(
                                            Icons.shuffle,
                                            size: 25.0,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  IconButton(
                                    onPressed: () => favouriteModel
                                        .collect(songModel.currentSong),
                                    icon: favouriteModel.isCollect(
                                                songModel.currentSong) ==
                                            true
                                        ? Icon(
                                            Icons.favorite,
                                            size: 25.0,
                                            color:
                                                Theme.of(context).accentColor,
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            size: 25.0,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  IconButton(
                                    onPressed: () => downloadModel
                                        .download(songModel.currentSong),
                                    icon: downloadModel
                                            .isDownload(songModel.currentSong)
                                        ? Icon(
                                            Icons.cloud_done,
                                            size: 25.0,
                                            color:
                                                Theme.of(context).accentColor,
                                          )
                                        : Icon(
                                            Icons.cloud_download,
                                            size: 25.0,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ]),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Text(
                              songModel.currentSong.author,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15.0),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              songModel.currentSong.title,
                              style: GetTextStyle.XL(context),
                            ),
                            Text(
                              songModel.currentSong.name_collection,
                              style: GetTextStyle.M(context),
                            ),
                          ],
                        )
                      : SongListCarousel(),
                ],
              ),
            ),
            Player(
              songData: songModel,
              downloadData: downloadModel,
              nowPlay: widget.nowPlay,
            ),
          ],
        ),
      ),
    );
  }
}

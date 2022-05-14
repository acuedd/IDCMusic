
import 'dart:io';

import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/marquee_widget.dart';
import 'package:church_of_christ/ui/widgets/player_carousel.dart';
import 'package:church_of_christ/ui/widgets/song_list_carrousel.dart';
import 'package:church_of_christ/utils/anims/player_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:markdown_widget/markdown_widget.dart';

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
      controllerPlayer.stop(canceled: false);
      //controllerPlayer.forward();
    } else {
      controllerPlayer.stop(canceled: false);
    }    

    //To manage screen height looks of ui
    double screenHeight = MediaQuery.of(context).size.height;
    double screenAspectRatio = 0;
    if(screenHeight>800){
      screenAspectRatio = 0.03;
    }
    else if(screenHeight>=600 && screenHeight <= 800){
      screenAspectRatio = 0.02;
    }
    else if(screenHeight <= 600){
      screenAspectRatio = 0.01;
    }

    var _future =  BaseRepository.fetchAnnotations(idResource: songModel.currentSong.songid);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                              
                AppBarCarrousel(title: "", iconBottom: true,),
                SizedBox(
                    height:
                        MediaQuery.of(context).size.height * screenAspectRatio),
                RotatePlayer(
                    animation:
                        _commonTween.animate(controllerPlayer)),
                SizedBox(
                    height:
                        MediaQuery.of(context).size.height * screenAspectRatio),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Theme(
                        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                        child: ModalTrigger(),
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
                                    Theme.of(context).colorScheme.secondary,
                              )
                            : Icon(
                                Icons.favorite_border,
                                size: 25.0,
                                color: Colors.grey,
                              ),
                      ),                                  
                      if(!Platform.isIOS)
                        IconButton(
                          onPressed: () async{
                            var status = await Permission.storage.request();
                            if (status.isGranted) {
                              downloadModel
                              .download(songModel.currentSong);
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => CupertinoAlertDialog(
                                      title: Text('Permiso de almacenamiento'),
                                      content: Text(
                                          'El app necesita permiso para poder guardar las canciones descargadas en el almacenamiento del dispositivo.'),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text('Deny'),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        CupertinoDialogAction(
                                          child: Text('Settings'),
                                          onPressed: () => openAppSettings(),
                                        ),
                                      ],
                                    )
                                );
                            }
                          },
                          icon: downloadModel
                                  .isDownload(songModel.currentSong)
                              ? Icon(
                                  Icons.cloud_done,
                                  size: 25.0,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )
                              : Icon(
                                  Icons.cloud_download,
                                  size: 25.0,
                                  color: Colors.grey,
                                ),
                        ),
                      IconButton(
                        onPressed: () => Utils.share(songModel.currentSong),
                        icon: Icon(
                                Icons.share_rounded,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: MarqueeWidget(
                    direction: Axis.horizontal,
                    child: Text(
                      songModel.currentSong.title,
                      style: GetTextStyle.L(context),
                    ),
                  ),
                ),
                Text(
                  songModel.currentSong.name_collection,
                  style: GetTextStyle.M(context),
                ),
            
                Player(
                  songData: songModel,
                  downloadData: downloadModel,
                  nowPlay: widget.nowPlay,
                ),                
                FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    try {
                      if (snapshot.data != null) {
                        if(snapshot.data["valido"] == 1){
                          String annotation = snapshot.data["first_annotation"];
                          String parseAnnotation =  annotation.replaceAll("\\n", "\n");
                          //String parseAnnotation =  parseAnnotationPre.replaceAll("\n", "\r");

                          debugPrint("fuck fuck -> $parseAnnotation");
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            child: Container(
                                height: 300,
                                width: 300,                                  
                                color: Theme.of(context).backgroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),                                  
                                  child: Markdown( 
                                    data: parseAnnotation,                                
                                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                      blockSpacing: 12, 
                                      h2: TextStyle( 
                                        fontSize: 17, 
                                        fontWeight: FontWeight.bold, 
                                        color: Theme.of(context).textTheme.headline6.color, 
                                        fontFamily: "ProductSans", 
                                      ), 
                                      p: TextStyle( 
                                        fontSize: 15, 
                                        color: Theme.of(context).textTheme.caption.color,
                                      )
                                    ),
                                  ),
                                ),
                            ),
                          );
                        }
                      }
                    }
                    catch(Error){

                    }
                    return Container();
                  }
                )                
              ],
            ),
          ),
      ),
    );
  }
}

class ModalTrigger extends StatelessWidget{

  _showModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            color: (Theme.of(context).brightness == Brightness.dark)? Theme.of(context).backgroundColor : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(children: [
            SizedBox(height: 30,),
            SongListCarousel()
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          _showModalBottomSheet(context);          
          //SongListCarousel();
        },
        icon: Icon(
          Icons.list,
          size: 25.0,
          color: Colors.grey,
        ),
      );  
  }
}

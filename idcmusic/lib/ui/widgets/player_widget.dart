

import 'dart:async';

import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:church_of_christ/ui/widgets/marquee_widget.dart';
import 'package:church_of_christ/utils/anims/record_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerWidget extends StatefulWidget{
  SongModel _songData;

  PlayerWidget(this._songData);
  
  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();

}

class _PlayerWidgetState extends State<PlayerWidget> {
  AnimationController controllerRecord; 
  Animation<double> animationRecord; 
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0); 
  final List<StreamSubscription> _subscriptions = [];
  String strTitle;
  String strArtist;
  String imagePath;

  @override
  void initState() {
     super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _showPlayer(context);

  Widget setIcon() {
    if (widget._songData.isPlaying)
      return Icon(Icons.pause);
    else
      return Icon(Icons.play_arrow);
  }

  Function setCallback(BuildContext context) {
    if(widget._songData.isPlaying){
      return () async{
        await widget._songData.audioPlayer.playOrPause();
        setState(() => widget._songData.setPlaying(false));
      };
    }
    else{
      return () async{
        await widget._songData.audioPlayer.playOrPause();
        setState(() => widget._songData.setPlaying(true));
      };
    }
  }

  Widget _showPlayer(BuildContext context){    
    
    if(widget._songData != null && widget._songData.songs != null){
      _subscriptions.add(widget._songData.audioPlayer.onReadyToPlay.listen((event) {
        //print("FUCK READY TO PLAY $event");
        if(strTitle != event.audio.metas.title){
          if (!mounted) return;
          setState(() {          
            strTitle = event.audio.metas.title;
            strArtist = event.audio.metas.artist;
            imagePath = event.audio.metas.extra["pic"];
          });   
        }        
      }));
    }

    return strTitle == null || widget._songData == null || widget._songData.songs == null
            ? SizedBox.shrink()
            : Container(
                height: 70.0,
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container( 
                      height: 50.0,
                      width: 50.0,
                      child: ClipRRect( 
                        borderRadius: BorderRadius.circular(12.0),
                        child: Utils.image(imagePath, fit: BoxFit.cover)
                      ),
                    ), 
                    SizedBox(width: 15.0,),
                    Expanded(                       
                      child: GestureDetector( 
                      onTap: (){
                        if(widget._songData.songs != null){
                          Navigator.push( context,
                            MaterialPageRoute(builder: (_) => PlayPage(nowPlay: false)),
                          );
                        }
                      }, 
                      child:Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(                         
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarqueeWidget(
                                direction: Axis.horizontal,
                                child: Text(
                                  strTitle,
                                  style: GetTextStyle.M(context),
                                ),
                              ),
                              SizedBox(height: 3.0,),
                              MarqueeWidget(
                                direction: Axis.horizontal,
                                child: Text( 
                                  strArtist, 
                                  style: GetTextStyle.S(context),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 45.0,
                      height: 45.0,
                      child: IconButton(
                          onPressed: setCallback(context),
                          icon: setIcon(),
                      ),                      
                    ),
                  ],
                ),
              ); 
  }
}
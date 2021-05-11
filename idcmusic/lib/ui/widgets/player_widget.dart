

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

class _PlayerWidgetState extends State<PlayerWidget> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{
  AnimationController controllerRecord; 
  Animation<double> animationRecord; 
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0); 
  final List<StreamSubscription> _subscriptions = [];
  Song mySong;

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
    return _showPlayer(context);
  }

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
    if(widget._songData.isPlaying){
      controllerRecord.forward();
    }
    else {
      controllerRecord.stop(canceled: false);
    }

    return widget._songData == null || widget._songData.songs == null 
            ? SizedBox.shrink()
            : Container(
                height: 60.0,
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container( 
                      height: 55.0,
                      width: 55.0,
                      child: RotateRecord(
                          animation: _commonTween.animate(controllerRecord),
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
                                  widget._songData.currentSong.title,
                                  style: GetTextStyle.M(context),
                                ),
                              ),
                              SizedBox(height: 3.0,),
                              MarqueeWidget(
                                direction: Axis.horizontal,
                                child: Text( 
                                  widget._songData.currentSong.author, 
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
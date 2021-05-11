import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


class Player extends StatefulWidget {
  final SongModel songData;
  final DownloadModel downloadData;

  final bool nowPlay;

  final double volume;

  final Key key;

  final Color color;

  final bool isLocal;

  Player(
      {@required this.songData,
      @required this.downloadData,
      this.nowPlay,
      this.key,
      this.volume: 1.0,
      this.color: Colors.white,
      this.isLocal: false});

  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State<Player> {
  Duration _duration;
  Duration _position;
  SongModel _songData;
  DownloadModel _downloadData;
  bool _isSeeking = false;
  final List<StreamSubscription> _subscriptions = [];
  AssetsAudioPlayer _audioPlayer;
  //AudioPlayerState _audioPlayerState;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _songData = widget.songData;
    _downloadData = widget.downloadData;
    _initAudioPlayer(_songData);    
    if (!_songData.isPlaying || widget.nowPlay) {
      _songData.setPlayNow(widget.nowPlay);
      play(_songData.currentSong);
    }    
  }

  void _initAudioPlayer(SongModel songData) {
    _audioPlayer = songData.audioPlayer;
    _position = _songData.position;
    _duration = _songData.duration;         

    _audioPlayer.current.listen((playingAudio) {
      try{
        final songDuration = playingAudio.audio.duration;
        if (!mounted) return;
        //print("fuck current $playingAudio");
        debugPrint("MSG - current index: ${playingAudio.playlist.currentIndex}");        
        debugPrint("MSG - next index ${playingAudio.playlist.nextIndex}");
        debugPrint("MSG - prev index ${playingAudio.playlist.previousIndex}");        
        
        setState(() {
          _duration = songDuration;                    
          if(_songData.playNow){
            _songData.setPlayNow(false);
          }
          else{
            _songData.setCurrentIndex(playingAudio.playlist.currentIndex);
          }
          _songData.setNextIndex(playingAudio.playlist.nextIndex);
          _songData.setPreviousIndex(playingAudio.playlist.previousIndex);
          
        });
      }
      catch(t){ }
    });

    _subscriptions.add( _audioPlayer.currentPosition.listen((position) {
      if (!mounted) return;
      setState(() {
        _position = position;
      });
    }));

    _subscriptions.add( _audioPlayer.loopMode.listen((loopMode) {
      if (!mounted) return;
      setState(() {
        _songData.setLoopMode(loopMode);
      });
    }));

    _subscriptions.add(_audioPlayer.isPlaying.listen((isPlaying) {
      //print("is playing $isPlaying");
      //
      _songData.setPlaying(isPlaying);
    }));
  }

  String getSongUrl(Song s) {
    return s.url;
    //return 'http://music.163.com/song/media/outer/url?id=${s.songid}.${s.ext}';
  }

  void play(Song s) async {      
    _audioPlayer.open( Playlist(audios: _songData.songsAudio, startIndex: _songData.currentSongIndex), 
      showNotification: true,
      loopMode: LoopMode.none,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      playInBackground: PlayInBackground.enabled,
      notificationSettings: NotificationSettings(
        customPrevAction: (player){
          debugPrint("MSG - prevAction");
          previous();
        }, 
        customNextAction: (player){
          debugPrint("MSG - nextAction");
          next();
        }
      )
    );
    setState(() => _songData.setPlaying(true));    
  }

  void pause() async {
    try{
      await _audioPlayer.playOrPause();
      setState(() => _songData.setPlaying(false));
    }
    catch(t){ }
  }

  void resume(){
    try{
      _audioPlayer.playOrPause();
      setState(() => _songData.setPlaying(true));
    }
    catch(t){ }
  }

  void next() {
    if(_songData.isShuffle){
      _audioPlayer.playlistPlayAtIndex(_songData.randomIndex);
    }
    else{
      _audioPlayer.next();
    }    
  }

  void previous() {    
    _audioPlayer.previous();
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = "$minute" + ":" + ((second < 10) ? "0$second" : "$second");
    return format;
  }

  @override
  Widget build(BuildContext context) {    
    return Column(    
      children: _controllers(context),
    );
  }

  Widget _timer(BuildContext context) {
    var style = new TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          _formatDuration(_position),
          style: style,
        ),
        new Text(
          _formatDuration(_duration),
          style: style,
        ),
      ],
    );
  }

  List<Widget> _controllers(BuildContext context) {
    return [
      Visibility(
        visible: !_songData.showList,
        child: new Slider(
          onChangeStart: (v) {
            _isSeeking = true;
          },
          onChanged: (value) {
            setState(() {
              _position =
                  Duration(seconds: (_duration.inSeconds * value).round());
            });
          },
          onChangeEnd: (value) {
            setState(() {
              _position =
                  Duration(seconds: (_duration.inSeconds * value).round());
            });
            _audioPlayer.seek(_position);
          },
          value: (_position != null &&
                  _duration != null &&
                  _position.inSeconds > 0 &&
                  _position.inSeconds < _duration.inSeconds)
              ? _position.inSeconds / _duration.inSeconds
              : 0.0,
          activeColor: Theme.of(context).accentColor,
        ),
      ),
      Visibility(
        visible: !_songData.showList,
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: _timer(context),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if(_songData.showList)
              Visibility(
                visible: _songData.showList,
                child: IconButton(
                  onPressed: () => _songData.setShowList(!_songData.showList),
                  icon: Icon(
                    Icons.list,
                    size: 25.0,
                    color: Colors.grey,
                  ),
                ),
              ),            
            IconButton(
              onPressed: () => previous(),
              icon: Icon(
                //Icons.skip_previous,
                Icons.skip_previous,
                size: 40.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).accentColor
                    : Color(0xFF787878),
              ),
            ),
            ClipOval(
                child: Container(
                color: Theme.of(context).accentColor.withAlpha(30),
                width: 70.0,
                height: 70.0,
                child: IconButton(
                  onPressed: () {
                    _songData.isPlaying ? pause() : resume();
                  },
                  icon: Icon(
                    _songData.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 45.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => next(),
              icon: Icon(
                //Icons.skip_next,
                Icons.skip_next,
                size: 40.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).accentColor
                    : Color(0xFF787878),
              ),
            ),            
          ],
        ),
      ),
    ];
  }

  /*void _onComplete() {
    setState(() => _songData.setPlayState(PlayState.stopped));
  }*/
}

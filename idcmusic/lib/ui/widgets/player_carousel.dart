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
    _songData = widget.songData;
    _downloadData = widget.downloadData;
    _initAudioPlayer(_songData);
    if (!_songData.isPlaying || widget.nowPlay) {
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
        setState(() {
          _duration = songDuration;
        });
      }
      catch(t){ }      
    });

    _audioPlayer.currentPosition.listen((position) {
      if (!mounted) return;
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.playlistAudioFinished.listen((Playing playing) {
      //print("fuck finish $playing");
      
      next();
    });

    _audioPlayer.isPlaying.listen((isPlaying) {
      //print("is playing $isPlaying");
      if (!mounted) return;
      setState(() {
        //_audioPlayerState = state;
        _songData.setPlaying(isPlaying);
      });
    });
  }

  String getSongUrl(Song s) {
    return s.url;
    //return 'http://music.163.com/song/media/outer/url?id=${s.songid}.${s.ext}';
  }

  void play(Song s) async {
    String url;
    bool isDownload;
    Audio audio;    
    if (_downloadData.isDownload(s)) {
      isDownload = true;
      url = _downloadData.getDirectoryPath + '/${s.songid}.${s.ext}';
      audio = Audio.file(
         url, 
         metas: Metas( 
            title: s.title, 
            artist: s.author, 
            album: s.name_collection, 
            //image: MetasImage.network(path)
         )
      );
    }
    else {
      isDownload = false;
      url = getSongUrl(s);
      audio = Audio.network(
         url, 
         metas: Metas( 
            title: s.title, 
            artist: s.author, 
            album: s.name_collection,
            image: MetasImage.network(s.pic)
         )
      );
    }

    if (url == _songData.url) {      
        await _audioPlayer.open( audio, 
                showNotification: true, 
                headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug, 
                notificationSettings: NotificationSettings(
                  customPrevAction: (player){
                    print("prevAction");
                    print(player);
                  }, 
                  customNextAction: (player){
                    print("nextAction");
                    print(player);
                  }
                )
              );
        _songData.setPlaying(true);
        _audioPlayer.onErrorDo = (handler){
          _songData.setPlaying(false);
          if(isDownload){
            Toast.show("Ha ocurrido un error, quita la canción de tus descargas e intenta nuevamente", context, gravity: Toast.BOTTOM);
          }
          else{
            Toast.show("El audio no se puede cargar, revisa tu conexión", context, gravity: Toast.BOTTOM);
          }
          next();
        };        
    }
    else {
      await _audioPlayer.open( audio, 
              showNotification: true, 
              headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
              notificationSettings: NotificationSettings(
                  customPrevAction: (player){
                    print("prevAction");
                    print(player);
                    previous();
                  }, 
                  customNextAction: (player){
                    print("nextAction");
                    print(player);
                    next();
                  }
                )
            );
      _songData.setPlaying(true);
      _songData.setUrl(url);
      _audioPlayer.onErrorDo = (handler){
        _songData.setPlaying(false);
        if(isDownload){
          Toast.show("Ha ocurrido un error, quita la canción de tus descargas e intenta nuevamente", context, gravity: Toast.BOTTOM);
        }
        else{
          Toast.show("El audio no se puede cargar, revisa tu conexión", context, gravity: Toast.BOTTOM);
        }
        next();
      };
    }
  }

  void pause() async {
    try{
      await _audioPlayer.playOrPause();
      setState(() => _songData.setPlaying(false));
    }
    catch(t){

    }
  }

  void resume() async {
    try{
      await _audioPlayer.playOrPause();
      setState(() => _songData.setPlaying(true));
    }
    catch(t){ }
  }

  void next() {
    Song data = _songData.nextSong;
    while (data.url == null) {
      data = _songData.nextSong;
    }
    play(data);
  }

  void previous() {
    Song data = _songData.prevSong;
    while (data.url == null) {
      data = _songData.prevSong;
    }
    play(data);
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
    if (_songData.playNow) {
      play(_songData.currentSong);
    }
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
                Icons.fast_rewind,
                size: 25.0,
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
                  size: 30.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            )),
            IconButton(
              onPressed: () => next(),
              icon: Icon(
                //Icons.skip_next,
                Icons.fast_forward,
                size: 25.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).accentColor
                    : Color(0xFF787878),
              ),
            ),
            Visibility(
              visible: _songData.showList,
              child: IconButton(
                onPressed: () => _songData.changeRepeat(),
                icon: _songData.isRepeat == true
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

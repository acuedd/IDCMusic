import 'dart:async';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
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
          _songData.setUrl(_songData.songs[_songData.currentSongIndex].url);          
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

    /*_subscriptions.add( _audioPlayer.playlistAudioFinished.listen((event) {
      debugPrint("MSG - $event");
      if(_songData.isShuffle){
        _audioPlayer.stop();
        _audioPlayer.playlistPlayAtIndex(_songData.randomIndex);
      }
    }));*/

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
    DownloadModel downloadModel = Provider.of(context);
    FavoriteModel favouriteModel = Provider.of(context);
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
        child: new Column(
          children: [
            if(_songData.showList)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [              
                Visibility(
                  visible: _songData.showList,
                  child: IconButton(
                    onPressed: () => _songData.setShowList(!_songData.showList),
                    icon: Icon(
                      Icons.list,
                      size: 25.0,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => favouriteModel
                      .collect(_songData.currentSong),
                  icon: favouriteModel.isCollect(
                              _songData.currentSong) ==
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
                if(!Platform.isIOS)
                  IconButton(
                    onPressed: () async{
                      var status = await Permission.storage.request();
                      if (status.isGranted) {
                        downloadModel
                        .download(_songData.currentSong);
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
                            .isDownload(_songData.currentSong)
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
                IconButton(
                  onPressed: () => Utils.share(_songData.currentSong),
                  icon: Icon(
                          Icons.share_rounded,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                ),                
            ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[              
                IconButton(
                  onPressed: (){
                    final List<Song> shuffleSongs = Utils.shuffle(_songData.songs);
                    _songData.audioPlayer.stop();
                    _songData.setSongs(shuffleSongs, context);
                    _songData.setCurrentIndex(0);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayPage(
                          nowPlay: true,
                        ),
                      ),
                    );
                    _songData.changeSuffle();
                  },
                  icon: _songData.isShuffle == false
                      ? Icon(
                          Icons.shuffle,
                          size: 25.0,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.shuffle,
                          size: 25.0,
                          color: Theme.of(context).accentColor
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
                IconButton(
                  onPressed: () => _songData.changeRepeat(),
                  icon: _songData.loopMode == LoopMode.none
                      ? Icon(
                          Icons.repeat,
                          size: 25.0,
                          color: Colors.grey,
                        )
                      : _songData.loopMode == LoopMode.playlist
                        ? Icon(
                            Icons.repeat,
                            size: 25.0,
                            color: Theme.of(context).accentColor
                          )
                        : Icon(
                            Icons.repeat_one,
                            size: 25.0,
                            color: Theme.of(context).accentColor
                          )
                ),
              ],
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

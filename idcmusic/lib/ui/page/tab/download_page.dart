import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/ui/widgets/empty_widget.dart';
import 'package:church_of_christ/ui/widgets/player_widget.dart';
import 'package:church_of_christ/ui/widgets/songItem.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:church_of_christ/utils/anims/record_anim.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MusicPage extends StatefulWidget{
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{

  AnimationController controllerRecord; 
  Animation<double> animationRecord; 
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0); 

  @override
  void initState() {
    super.initState();
    loadData();
    
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

  loadData() async{
    final dir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = dir.listSync();
    for(var file in files){
      //print(file.path);
    }
    setState(() { });
  }

  @override
  void dispose() {
    controllerRecord.dispose();
    super.dispose();    
  }

  @override
  bool get wantKeepAlive => true;  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    DownloadModel downloadModel = Provider.of(context);
    SongModel songModel = Provider.of(context);
    if(songModel.isPlaying){
      controllerRecord.forward();
    }
    else {
      controllerRecord.stop(canceled: false);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Descargas",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2)
              ),
            ),
            Expanded(
              child: downloadModel.downloadSong.length == 0
                ? Center(
                    child:  EmptyWidget(
                      title: 'No tienes descargas',
                      description: 'Aún no descargas\n ninguna de tus canciones favoritas',
                    ),
                  )
                : ListView.builder(
                  itemCount: downloadModel.downloadSong.length,
                  itemBuilder: (BuildContext context, int index){
                    Song data = downloadModel.downloadSong[index];
                    return GestureDetector(
                      onTap: (){
                        if(null != data.url){
                          SongModel songModel = Provider.of(context, listen: false);
                          songModel.setSongs( new List<Song>.from(
                            downloadModel.downloadSong
                          ), context);
                          songModel.setCurrentIndex(index);
                          Navigator.push(context,
                            MaterialPageRoute(builder: (_) => PlayPage( nowPlay: true,))
                          );
                        }
                      },
                      child: SongItem(song: data,),
                    );
                  },
                )
              ,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar( 
        child: PlayerWidget(songModel),
      ),
    );
  }

}
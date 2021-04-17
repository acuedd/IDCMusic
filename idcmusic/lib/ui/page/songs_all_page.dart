

import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/provider/view_state_widget.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/loader.dart';
import 'package:church_of_christ/ui/widgets/songItem.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SongsAllCarousel extends StatefulWidget{
  final bool recently;
  final String strTitle;
  SongsAllCarousel({this.recently = false, this.strTitle =  "Todas las canciones"});

  _SongsAllCarouselState createState() => _SongsAllCarouselState();
}

class _SongsAllCarouselState extends State<SongsAllCarousel>{

  List<Song>  convertResponseToListSong(data){
    List<Song> response = [];

    for(var i = 0; i<data.length; i++){

      Map<String,dynamic> mySong = Map<String,dynamic>();
      mySong["type"] = "netease";
      mySong["link"] = "${Url.getURL()}/${data[i]["path"]}";
      mySong["songid"] = data[i]["id_resource"];
      mySong["title"] = data[i]["title_resource"];
      mySong["author"] = data[i]["fullname"];
      mySong["lrc"] = data[i]["duration"];
      mySong["url"] = "${Url.getURL()}/${data[i]["path"]}";
      mySong["pic"] = "${Url.getURL()}/${data[i]["path_image"]}";
      mySong["sourcetype"] = data[i]["sourcetype"];
      mySong["name_collection"] = data[i]["name_collection"];
      mySong["ext"] = data[i]["ext"];
      mySong["tags"] = data[i]["tags"];
      response.add(Song.fromJsonMap(mySong));
    }

    return response;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( 
        child: Column( 
          children: <Widget>[
            AppBarCarrousel(title: widget.strTitle, iconBottom: true,), 
            Expanded( 
              child: ProviderWidget<SongListModel>( 
                onModelReady: (model) async{
                  await model.initData();
                },
                model: SongListModel(recently: widget.recently),
                builder: (context, model,child){
                  List<Song> mylist = convertResponseToListSong(model.list["resources"] ?? []);
                  if(model.busy){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(child: Text("Cargando..."),),
                        Loader(),
                      ],
                    );
                  }
                  else if(model.error && model.list["valido"] == 0){
                    return ViewStateEmptyWidget(onPressed: model.initData());
                  }

                  return SmartRefresher(
                    controller: model.refreshController, 
                    header: WaterDropHeader(),
                    enablePullUp: true,
                    onRefresh: ()async{
                      await model.refresh();
                      model.showErrorMessage(context);
                    },
                    child: ListView.builder(
                      itemCount: mylist.length,
                      itemBuilder: (context, index){
                        Song data = mylist[index];
                        return GestureDetector(
                          onTap: (){
                            if(null != data.url){
                              SongModel songModel = Provider.of(context, listen: false);
                              songModel.setSongs(mylist);
                              songModel.setCurrentIndex(index);
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (_) => PlayPage(nowPlay: true,)
                                )
                              );
                            }
                          },
                          child: SongItem(song: data,),
                        );
                      }
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
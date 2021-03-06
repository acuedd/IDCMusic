


import 'package:church_of_christ/ui/widgets/loader.dart';
import 'package:church_of_christ/ui/widgets/songItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:provider/provider.dart';
import 'package:church_of_christ/utils/url.dart';

class AlbumCarousel extends StatefulWidget{
  final String input;

  AlbumCarousel({this.input});

  @override
  _AlbumCarouselState createState() => _AlbumCarouselState();
}

class _AlbumCarouselState extends State<AlbumCarousel>{  

  List<Song>  convertResponseToListSong(data){
    List<Song> response = [];

    for(var i = 0; i<data.length; i++){

      Map<dynamic,dynamic> mySong = Map<dynamic,dynamic>();
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
    return ProviderWidget<AlbumListModel>(  
      onModelReady: (model) async{
        await model.initData();
      },
      model: AlbumListModel(input: widget.input),
      builder: (context, model, child){
        List<Song> mylist = convertResponseToListSong(model.list["resources"] ?? []);
        //print(mylist);
        return mylist.length == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(child: Text("Cargando..."),),
                Loader(),
              ],
            )
          : Column(
            children: [
              Row( 
                children: <Widget>[
                  Expanded( 
                    flex: 1,
                    child: GestureDetector(                       
                      onTap: (){
                        SongModel songModel = Provider.of(context, listen: false); 
                        songModel.setSongs(mylist, context);
                        setState((){ songModel.setCurrentIndex(0); });
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => PlayPage(
                            nowPlay: true,
                          )),
                        );
                      },
                      child: Container(
                        height: 70,
                        margin: EdgeInsets.only( top: 20, bottom: 20, left: 20, right: 10),
                        decoration: BoxDecoration( 
                          border: Border.all(color: Colors.black12, width: 1), 
                          borderRadius: BorderRadius.circular(20.0), 
                        ),                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Icon( 
                            Icons.play_arrow, 
                            color: Theme.of(context).accentColor,
                          ), 
                          SizedBox(width: 5,), 
                          Text( 
                            'Play', 
                            style: TextStyle( color: Theme.of(context).accentColor),
                          )
                        ])
                      ),                        
                    ),
                  ),
                ],
              ), 
              Container( 
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: new NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: mylist.length,
                  itemBuilder: (BuildContext context, int index){              
                    Song data = mylist[index];           
                    return GestureDetector( 
                      onTap: (){
                        if(null != data.url){
                          SongModel songModel = Provider.of(context, listen: false); 
                          songModel.setSongs(mylist, context);
                          songModel.setCurrentIndex(index);
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (_) => PlayPage(
                              nowPlay: true,
                            )),
                          );
                        }
                      },
                      child: SongItem(song: data,index: index+1,),
                      //_buildSongItem(data, index + 1),
                    );
                  }
                ),
              )
            ],
          );        
      },
    );
  }
}


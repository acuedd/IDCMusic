import 'package:church_of_christ/ui/widgets/loader.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/provider/view_state_widget.dart';
import 'package:church_of_christ/ui/helper/refresh_helper.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget{
  final String input; 

  SearchPage({this.input});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  Widget _buildSongItem( Song data ){
    return Padding( 
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row( 
        children: <Widget>[
          ClipRRect( 
            borderRadius: BorderRadius.circular(12.0),
            child: Container(width: 50, height: 50, child: Image.network(data.pic)),
          ), 
          SizedBox(width: 20.0,), 
          Expanded( 
            child: Column(  
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text( 
                  data.title, 
                  style: data.url == null 
                    ? TextStyle( 
                      fontSize: 12.0, 
                      fontWeight: FontWeight.w600, 
                      color: Color(0XFFE0e0e0), 
                    )
                    : TextStyle( 
                      fontSize: 12.0, 
                      fontWeight: FontWeight.w600, 
                    ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ), 
                SizedBox(height: 10),
                Text(  
                  data.author, 
                  style: data.url == null 
                    ? TextStyle( 
                      fontSize: 10.0, 
                      color: Color(0xFFE0E0E0), 
                    )
                    : TextStyle( 
                      fontSize: 10.0, 
                      color: Colors.grey, 
                    ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),                 
              ],
            ),
          ), 
          data.url == null 
            ? Icon( 
                Icons.favorite_border, 
                color: Color(0xFFE0E0E0),
                size: 20.0,
              )
            : Icon( 
                Icons.favorite_border, 
                size: 20.0,
              ),
        ],
      ),
    );
  }

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
            AppBarCarrousel(title: "",), 
            Container( 
              margin: EdgeInsets.only(bottom: 40),
              alignment: Alignment.center,
              child: Text('Resultados de: '+ widget.input),
            ), 
            Expanded(
              child: ProviderWidget<SongListModel>( 
                onModelReady: (model) async{
                  await model.initData();
                },
                model: SongListModel(input: widget.input),
                builder: (context, model, child){
                  List<Song> mylist = convertResponseToListSong(model.list["resources"] ?? []);
                  if(model.busy){
                    return Column(
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
                    enablePullUp: false,
                    onRefresh: () async{
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
                          child: _buildSongItem(data),
                        );
                      },
                    ),                    
                  );
                },
              ),
            ), 
          ],
        ),
      ),
    );
  }
}
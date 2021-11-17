

import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:church_of_christ/ui/widgets/loader.dart';
import 'package:church_of_christ/ui/widgets/songItem.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ArtistCarousel extends StatefulWidget{
  final String input;

  ArtistCarousel({this.input});

  @override
  _ArtistCarouselState createState() => _ArtistCarouselState();
}

class _ArtistCarouselState extends State<ArtistCarousel>{

  @override
  Widget build(BuildContext context) {
    
    return ProviderWidget<AuthorsListModel>(  
      onModelReady: (model) async{
        await model.initData();
      },
      model: AuthorsListModel(input: widget.input),
      builder: (context, model, child){
        List<Song> mylist = convertResponseToListSong(model.list["resources"] ?? []);
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
                    child: InkWell(                       
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
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15.0)),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Icon( 
                              Icons.play_arrow, 
                              color: (Brightness.dark == Theme.of(context).brightness) 
                                ? Theme.of(context).bottomAppBarColor
                                : Theme.of(context).bottomAppBarColor,
                            ), 
                            SizedBox(width: 5,), 
                            Text( 
                              'Play', 
                              style: GetTextStyle.LXL(context, color: Theme.of(context).bottomAppBarColor),
                            )
                          ])
                        )
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
                    return SongItem(song: data,index: index, songs: mylist, notShowImage: true,);
                  }
                ),
              )
            ],
          );   
      },
    );
  }
}
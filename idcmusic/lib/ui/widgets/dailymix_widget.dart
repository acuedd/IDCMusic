import 'dart:math';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyMixes extends StatefulWidget{
  List mixes;
  DailyMixes({this.mixes});

   @override
  _DailyMixesState createState() => _DailyMixesState();
}

class _DailyMixesState extends State<DailyMixes>{

  @override
  Widget build(BuildContext context) {
    List colors = [Colors.purple[400], Colors.orangeAccent[400], Colors.blue[400]];
    List colorsDark = [Colors.red, Colors.orange, Colors.blue[900]];
    Random random = new Random();
    int intRandNumber = random.nextInt(3);

    List labels = ["Principiante", "Maestro", "Leyenda"];
    SongModel songModel = Provider.of(context, listen: false);  
    return Column(
      children: [
      Padding( 
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Descubrir música",
              style: GetTextStyle.XL(context),
            ),            
          ],
        ),
      ),
      Container(
        height: 100,
        alignment: Alignment.center,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index){
            List<Song> songs = widget.mixes[index];

            return Container( 
              alignment: Alignment.center,
              child: Padding(
              padding: const EdgeInsets.only(left: 8.0),              
                child: Material( 
                  elevation: 8.0,
                  color: (Theme.of(context).brightness == Brightness.dark)?colorsDark[index ]: colors[index],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.antiAlias,                
                  child: InkWell(
                    onTap: (){
                        var i = random.nextInt(songs.length);                    
                        songModel.setSongs(songs, context);
                        songModel.setCurrentIndex(0);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayPage(
                              nowPlay: true,
                            ),
                          ),
                        );
                    },
                    child: 
                        Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          child: Column( 
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              Text("Mix Diario", style: GetTextStyle.L(context),),
                              Icon(
                                Icons.play_arrow,
                                size: 50.0,
                                textDirection: TextDirection.ltr,
                              ),
                              Text("${labels[index]}", style: GetTextStyle.M(context),),
                            ]                          
                          )
                        )
                  ),
                ),              
              ),
            )             ;
          },
        )        
      )
    ]);
  }
}
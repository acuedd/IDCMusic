

import 'package:church_of_christ/model/artist_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/artist_carousel.dart';
import 'package:church_of_christ/ui/widgets/player_widget.dart';
import 'package:church_of_christ/utils/colors.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistPage extends StatefulWidget{
  final Author author;
  final image;

  ArtistPage(this.author, {this.image});

  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    SongModel songModel = Provider.of(context);
    return Scaffold(
      body: SafeArea( 
        child: Column(  
          children: [
            AppBarCarrousel(title: "",), 
            Expanded( 
              child: ListView(  
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child:Container( 
                        height: height * 0.43,
                        width: width,                        
                        child: LayoutBuilder( 
                          builder: (context, constraints){
                            double innerHeight = constraints.maxHeight;
                            double innerWidth = constraints.maxWidth;
                            return Stack( 
                              fit: StackFit.expand,                              
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container( 
                                    height: innerHeight * 0.72,
                                    width: innerWidth,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [secondColor, Color(0xff64B6FF)],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      color: (Brightness.dark == Theme.of(context).brightness)
                                        ? secondColor
                                        : Colors.black45,
                                    ),
                                    child: Column( 
                                      children: [
                                        SizedBox(
                                          height: 110,
                                        ),
                                        Text(
                                          widget.author.fullname,
                                          style: GetTextStyle.LXL(context),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row( 
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                /*Positioned(
                                  top: 110,
                                  right: 20,
                                  child: Icon(
                                    AntDesign.setting,
                                    color: Colors.grey[700],
                                    size: 30,
                                  ),
                                ),*/
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container( 
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      height: MediaQuery.of(context).size.width * 0.5,
                                      child: ClipRRect( 
                                        borderRadius: BorderRadius.circular(30.0),
                                        child: (widget.image != null)
                                        ? widget.image
                                        : Container(child: Utils.image(widget.author.path_image),),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              
                            );
                          },
                        ),
                      ),
                  ),                  
                  ArtistCarousel(input: widget.author.id,),
                ]
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar( 
        child: PlayerWidget(songModel),
      )
    );
  }
}
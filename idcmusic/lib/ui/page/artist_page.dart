

import 'package:church_of_christ/model/artist_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/artist_carousel.dart';
import 'package:church_of_christ/ui/widgets/player_widget.dart';
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
    SongModel songModel = Provider.of(context);
    return Scaffold(
      body: SafeArea( 
        child: Column(  
          children: [
            AppBarCarrousel(title: "",), 
            Expanded( 
              child: ListView(  
                children: <Widget>[
                  Center( 
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
                  SizedBox(height: 20.0,), 
                  Center( 
                    child: Text( 
                      widget.author.fullname,
                      style: TextStyle(fontSize: 12.0),
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
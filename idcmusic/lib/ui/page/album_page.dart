

import 'package:church_of_christ/model/collections_model.dart';
import 'package:church_of_christ/ui/widgets/album_carousel.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/item_collection.dart';
import 'package:flutter/material.dart';

class AlbumsPage extends StatefulWidget{
  final Collection album; 
  final imageAlbum image;

  AlbumsPage(this.album, {this.image });

  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: SafeArea( 
        child: Column( 
          children: <Widget>[
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
                          : Container(child: Image.network(widget.album.path_image),),
                      ),
                    ),
                  ), 
                  SizedBox(height: 20.0,), 
                  Center( 
                    child: Text( 
                      widget.album.name_collection,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Center( 
                    child: Text( 
                      widget.album.fullname,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),                  
                  AlbumCarousel(input: widget.album.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
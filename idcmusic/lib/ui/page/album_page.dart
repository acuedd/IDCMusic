

import 'package:church_of_christ/model/collections_model.dart';
import 'package:church_of_christ/ui/widgets/album_carousel.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class AlbumsPage extends StatefulWidget{
  final Collection album; 

  AlbumsPage({this.album});

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
                        child: Container(child: Image.network(widget.album.path_image),),
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
                  Row( 
                    children: <Widget>[
                      Expanded( 
                        flex: 1,
                        child: Container( 
                          height: 70,
                          margin: EdgeInsets.only( top: 20, bottom: 20, left: 20, right: 10),
                          decoration: BoxDecoration( 
                            border: Border.all(color: Colors.black12, width: 1), 
                            borderRadius: BorderRadius.circular(20.0), 
                          ),
                          child: Row( 
                            mainAxisAlignment: MainAxisAlignment.center,                            
                            children: <Widget>[
                              Icon( 
                                Icons.play_arrow, 
                                color: Theme.of(context).accentColor,
                              ), 
                              SizedBox(width: 5,), 
                              Text( 
                                'Play', 
                                style: TextStyle( color: Theme.of(context).accentColor),
                              )
                            ],
                          ),
                        ),
                      ),                       
                    ],
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
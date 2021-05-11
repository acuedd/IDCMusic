import 'package:church_of_christ/model/collections_model.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/item_collection.dart';
import 'package:church_of_christ/ui/widgets/loader.dart';
import 'package:church_of_christ/ui/widgets/player_widget.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/provider/view_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:church_of_christ/model/song_model.dart';

class AlbumGridCarousel extends StatefulWidget{

  AlbumGridCarousel();

  _AlbumGridCarouselState createState() => _AlbumGridCarouselState();
}

class _AlbumGridCarouselState extends State<AlbumGridCarousel>{

  @override
  Widget build(BuildContext context) {
    SongModel songModel = Provider.of(context);
    return Scaffold(
      body: SafeArea( 
        child: Column( 
          children: <Widget>[
            AppBarCarrousel(title: "Albums", iconBottom: true,), 
            Expanded(
              child: ProviderWidget<AlbumModel>( 
                onModelReady: (model) async{
                  await model.initData();
                },
                model: AlbumModel(),
                builder: (context, model, child){
                  CollectionModel collectionModel = CollectionModel.fromJson(model.list);
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
                    onRefresh: () async{
                      await model.refresh();
                      model.showErrorMessage(context);
                    },
                    child: GridView.count(
                        crossAxisCount: 2, 
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 10.0,
                        children: collectionModel.collections.map((album){
                          return itemCollection(album: album, index: 1, length: 1,);
                        }).toList(),
                      ),
                  );                  
                },
              ),
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
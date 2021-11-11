

import 'package:church_of_christ/model/artist_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/provider/view_state_widget.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/item_author.dart';
import 'package:church_of_christ/ui/widgets/loader.dart';
import 'package:church_of_christ/ui/widgets/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArtistGridCarousel extends StatefulWidget{
  ArtistGridCarousel();

  _ArtistGridCarouselState createState() => _ArtistGridCarouselState();
}

class _ArtistGridCarouselState extends State<ArtistGridCarousel>{
  @override
  Widget build(BuildContext context) {
    SongModel songModel = Provider.of(context);
    return Scaffold(
      body: SafeArea( 
        child: Column( 
          children: <Widget>[
            AppBarCarrousel(title: "Artistas ", iconBottom: true,), 
            Expanded(
              child: ProviderWidget<ArtistModel>(
                onModelReady: (model) async{
                  await model.initData();
                },
                model: ArtistModel(),
                builder: (context, model, child){
                  AuthorModel authorModel = AuthorModel.fromJson(model.list);
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
                      children: authorModel.authors.map((a){
                        return itemAuthor(author: a, index: 1, length: 1,);
                      }).toList(),
                    ),
                  );
                },
              )
            )
          ]
        )
      ),
      bottomNavigationBar: BottomAppBar( 
        child: PlayerWidget(songModel),
      ),
    );
  }
}
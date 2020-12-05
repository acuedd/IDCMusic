import 'package:church_of_christ/bloc/bloc/AlbumBloc.dart';
import 'package:church_of_christ/generals/features/generalRequestEvent.dart';
import 'package:church_of_christ/generals/features/generalRequestStatus.dart';
import 'package:church_of_christ/player/models/collections_model.dart';
import 'package:church_of_christ/player/ui/widgets/item_collection.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:church_of_christ/utils/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselCollection extends StatefulWidget{
  
  CarouselCollection();

  @override
  _CarouselCollection createState() => _CarouselCollection();
}

class _CarouselCollection extends State<CarouselCollection> {
  AlbumBloc albumBloc;

    @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    albumBloc =  BlocProvider.of<AlbumBloc>(context);
  }

  Future<void> _updateData() async{
     albumBloc.add(FetchCollections());
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(       
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppBarCarrousel(title: "Albums",),
            Expanded(  
              child: RefreshIndicator(
                onRefresh: _updateData,
                child: BlocBuilder<AlbumBloc, RequestState>(  
                  builder: (context, state){       
                    if(state is RequestEmpty){
                      albumBloc.add(FetchCollections());
                    }                    
                    else if( state is RequestError){
                      return Center(
                        child: Text("Error",
                          style: GetTextStyle.XXL(context),
                        ),
                      );
                    }                    
                    else if(state is RequestLoaded){
                      //state.response2 is to collections,
                      return _getBody(state.response);
                    }
                    else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container();
                  }
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _showListCollections({data}){    
    CollectionModel collectionModel = CollectionModel.fromJson(data);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        children: collectionModel.collections.map((album){
          return itemCollection(album: album, index: 1, length: 1,);
        }).toList(),
      ),
    );      
  }

  Widget _getBody(data){        
    if(data["valido"] != 1){
      return Center(
        child: Text(
          data["razon"].toString().split("\n")[0],
          style: TextStyle( fontFamily: "Nunito",fontSize: 17.0,),
        )          
      );
    }
    else{
      return _showListCollections(data:data);        
    }
  }
}
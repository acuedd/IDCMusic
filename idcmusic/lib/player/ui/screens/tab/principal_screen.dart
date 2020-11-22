import 'package:church_of_christ/bloc/bloc/idc_bloc.dart';
import 'package:church_of_christ/bloc/repository/idc_api.dart';
import 'package:church_of_christ/generals/features/generalRequestEvent.dart';
import 'package:church_of_christ/generals/features/generalRequestStatus.dart';
import 'package:church_of_christ/player/models/collections_model.dart';
import 'package:church_of_christ/player/models/songs_model.dart';
import 'package:church_of_christ/player/ui/widgets/album_carousel.dart';
import 'package:church_of_christ/player/ui/widgets/for_you_carousel.dart';
import 'package:church_of_christ/player/ui/widgets/item_collection.dart';
import 'package:church_of_christ/player/ui/widgets/record_anim.dart';
import 'package:church_of_christ/player/ui/widgets/search.dart';
import 'package:church_of_christ/player/ui/widgets/songItem.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PrinciapalScreen extends StatefulWidget{
  const PrinciapalScreen({
    Key key,
  }) : super(key:key);

  @override
  State createState() {
    return _PrinciapalScreen();
  }
}

class _PrinciapalScreen extends State<PrinciapalScreen>
  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  final _inputController = TextEditingController();
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  Map<dynamic, dynamic> dataCollections = {};
  Map<dynamic, dynamic> dataSongs = {};
  
  IDCBloc idcBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controllerRecord = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationRecord = new CurvedAnimation(parent: controllerRecord, curve: Curves.linear);
    animationRecord.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        controllerRecord.repeat();
      }
      else if(status == AnimationStatus.dismissed){
        controllerRecord.forward();
      }
    });

    idcBloc =  BlocProvider.of<IDCBloc>(context);
  }

  @override
  void dispose() {
    _inputController.dispose();
    controllerRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _getHeader(),
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          controller: _inputController,
                          onChanged: (value){},
                          onSubmitted: (value){
                            if(value.isNotEmpty == true){

                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            hintText: "Buscar",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: RotateRecord(
                        animation: _commonTween.animate(controllerRecord),
                        onTap: () {
                          print("fuck here");
                          //idcBloc.add(FetchFirstPagePlayer());
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(  
                    child: BlocBuilder<IDCBloc, RequestState>(
                    
                    builder: (context, state){       
                        if(state is RequestEmpty){
                          idcBloc.add(FetchFirstPagePlayer());
                        }               
                        if( state is RequestError){
                            return Center(
                              child: Text("Error",
                                style: TextStyle( fontFamily: "Nunito", fontSize: 17.0),
                              ),
                            );
                        }
                        if(state is RequestLoadedDual){                      
                          return ListView(
                            children: <Widget>[
                              SizedBox(height: 10,),
                              _getBody(state.response1, "collections"),
                              _getBody(state.response0, "songs"),
                            ],
                          );
                        }
                        
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }),
                ),                                          
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: (){
          idcBloc.add(FetchFirstPagePlayer());
        },
      ),
    );

  }

  Widget _drawListCollections({data}){    
    CollectionModel collectionModel = CollectionModel.fromJson(data);  
    return AlbumsCarousel(collectionModel.collections);
  }

  Widget _drawListSongs({data}){
    SongModel songModel = SongModel.fromJson(data);
    return ForYouCarousel(songModel.songs);
  }

  Widget _getBody(data, strfrom){    
    
      if(data["valido"] != 1){
        return Center(
          child: Text(
            data["razon"].toString().split("\n")[0],
            style: TextStyle( fontFamily: "Nunito",fontSize: 17.0,),
          )
        );
      }
      else{
        if(strfrom =="collections"){
          return _drawListCollections(data:data);
        }
        else if (strfrom == "songs"){
          return _drawListSongs(data: data);
        }
      }
  }

  


}
import 'dart:async';
import 'package:church_of_christ/bloc/repository/idc_api.dart';
import 'package:church_of_christ/generals/features/generalRequestEvent.dart';
import 'package:church_of_christ/generals/features/generalRequestStatus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SongAlbumBloc extends Bloc<RequestEvent,RequestState>{
  final IDCRepository repository;

  SongAlbumBloc({ this.repository }) : assert(repository != null), super(RequestEmpty());

  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async*{
    if(event is InitialEvent){
      yield RequestEmpty();
    }
    else if(event is FetchSongByAlbum){
      try{
        final response = await repository.fetchSongs(idCollection: event.idAlbum.toString());
        yield RequestLoaded(response: response);
      }
      catch(_){
        yield RequestError();
      }
    }
  }
}
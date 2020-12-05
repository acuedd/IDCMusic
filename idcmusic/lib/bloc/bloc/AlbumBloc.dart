import 'dart:async';
import 'package:church_of_christ/bloc/repository/idc_api.dart';
import 'package:church_of_christ/generals/features/generalRequestEvent.dart';
import 'package:church_of_christ/generals/features/generalRequestStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlbumBloc extends Bloc<RequestEvent, RequestState>{
  final IDCRepository repository;

  AlbumBloc({ @required this.repository }) : assert(repository != null), super(RequestEmpty());

  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async*{
      if(event is InitialEvent){
        yield RequestEmpty();
      }
      else if(event is FetchSongs){
        yield* _mapFetchSonsToState(event);
      }
      else if(event is FetchCollections){
        yield* _mapFetchCollectionsToState(event);
      }
    }

  Stream<RequestState> _mapFetchCollectionsToState(RequestEvent event) async*{    
    try{
      final response = await repository.fetchCollections();
      yield RequestLoaded(response: response);
    }
    catch(_){
      yield RequestError();
    }
  }

  Stream<RequestState> _mapFetchSonsToState(RequestEvent event) async*{    
    try{
      final response = await repository.fetchSongs();
      yield RequestLoaded(response: response);
    }
    catch(_){
      yield RequestError();
    }
  }
}
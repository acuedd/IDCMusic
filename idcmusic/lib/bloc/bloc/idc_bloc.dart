import 'dart:async';


import 'package:church_of_christ/bloc/repository/idc_api.dart';
import 'package:church_of_christ/generals/features/generalRequestEvent.dart';
import 'package:church_of_christ/generals/features/generalRequestStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IDCBloc extends Bloc<RequestEvent, RequestState>{

  final IDCRepository repository;

  List<StreamSubscription> idcSubscriptions = new List();

  IDCBloc({ @required this.repository }) : assert(repository != null), super(RequestEmpty());

  @override
  RequestState get initialState => RequestEmpty();

  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async*{
    if(event is FetchChangeLog){
      yield RequestLoading();
      try{
        final response = await repository.fetchChangelog();
        yield RequestLoadedDio(response: response);
      }
      catch(_){
        yield RequestError();
      }
    }
    else if(event is FetchFirstPagePlayer){
      yield* _mapFetchFirstPagePlayerToState(event);
    }
    else if(event is FetchSongs){
      yield* _mapFetchSonsToState(event);
    }
    else if(event is FetchCollections){
      yield* _mapFetchCollectionsToState(event);
    }
  }

  Stream<RequestState> _mapFetchFirstPagePlayerToState(RequestEvent event) async*{
    yield RequestLoading();
      try{
        final responseSongs = await repository.fetchSongs();
        final responseCollections = await repository.fetchCollections();
        yield RequestLoadedDual(response0: responseSongs, response1: responseCollections);
      }
      catch(_){
        yield RequestError();
      }
  }

  Stream<RequestState> _mapFetchCollectionsToState(RequestEvent event) async*{
    yield RequestLoading();
      try{
        final response = await repository.fetchCollections();
        yield RequestLoaded(response: response);
      }
      catch(_){
        yield RequestError();
      }
  }

  Stream<RequestState> _mapFetchSonsToState(RequestEvent event) async*{
    yield RequestLoading();
    try{
      final response = await repository.fetchSongs();
      yield RequestLoaded(response: response);
    }
    catch(_){
      yield RequestError();
    }
  }
}

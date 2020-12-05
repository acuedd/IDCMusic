

import 'package:church_of_christ/bloc/repository/idc_api.dart';
import 'package:church_of_christ/generals/features/generalRequestEvent.dart';
import 'package:church_of_christ/generals/features/generalRequestStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeLogBloc extends Bloc<RequestEvent, RequestState>{
  final IDCRepository repository;
  
  ChangeLogBloc({ @required this.repository }):assert(repository != null), super(RequestEmpty());

  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async*{
    if(event is InitialEvent){
      yield RequestEmpty();
    }
    else if(event is FetchChangeLog){
      try{
        final dynamic response = await repository.fetchChangelog();
        yield RequestLoadedDio(response: response);
      }
      catch(_){
        yield RequestError();
      }
    }
  }
}
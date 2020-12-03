import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RequestState extends Equatable{
    const RequestState();

    @override
  List<Object> get props => [];
}

class RequestEmpty extends RequestState{ }

class RequestLoading extends RequestState{ }

class RequestLoadedDio extends RequestState{
  final dynamic response;

  const RequestLoadedDio({@required this.response}) : assert(response != null);

  @override
  List<Object> get props => [response];
}

class RequestLoaded extends RequestState{
  final Map<dynamic, dynamic> response;

  const RequestLoaded({ @required this.response }) : assert(response != null);

  @override
  List<Object> get props => [response];
}

class RequestLoadedDual extends RequestState{
  final Map<dynamic, dynamic> response0;
  final Map<dynamic, dynamic> response1;

  const RequestLoadedDual({ @required this.response0, @required this.response1 });

  @override
  List<Object> get props => [response0, response1];
}

class RequestError extends RequestState{ }
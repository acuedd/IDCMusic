import 'package:equatable/equatable.dart';

abstract class RequestEvent extends Equatable{
  const RequestEvent();
}

class FetchChangeLog extends RequestEvent{
  const FetchChangeLog();

  @override
  List<Object> get props => [];
}

class FetchFirstPagePlayer extends RequestEvent{
  const FetchFirstPagePlayer();

  @override
  List<Object> get props => [];
}

class FetchCollections extends RequestEvent{
  const FetchCollections();

  @override
  List<Object> get props => [];
}

class FetchSongs extends RequestEvent{
  const FetchSongs();

  @override
  List<Object> get props =>[];
}
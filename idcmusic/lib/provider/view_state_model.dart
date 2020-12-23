import 'package:church_of_christ/provider/view_state.dart';
import 'package:church_of_christ/provider/view_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/config/net/api.dart';
import 'package:oktoast/oktoast.dart';

import 'package:church_of_christ/provider/view_state.dart';

class ViewStateModel with ChangeNotifier{
  bool _disposed = false;

  ViewState _viewState;

  ViewStateModel({ ViewState viewState })
    : _viewState = viewState ?? ViewState.idle{
      //debugPrint('ViewStateModel---constructor--->$runtimeType');
  }

  ViewState get viewState => _viewState; 

  set viewState(ViewState viewState){
    _viewStateError = null;
    _viewState = viewState; 
    notifyListeners();
  }

  ViewStateError _viewStateError;
  
  ViewStateError get viewStateError => _viewStateError;

  String get errorMessage => _viewStateError?.message;

  bool get busy => viewState == ViewState.busy; 

  bool get idle => viewState == ViewState.idle; 

  bool get empty => viewState == ViewState.empty;

  bool get error => viewState == ViewState.error; 

  bool get unAuthorized => viewState == ViewState.unAuthorized;

  void setIdle(){
    viewState = ViewState.idle; 
  }

  void setBusy(){
    viewState = ViewState.busy;
  }

  void setEmpty(){
    viewState = ViewState.empty; 
  }

  void setUnAuthorized(){
    viewState = ViewState.unAuthorized;
    onUnAuthorizedException();
  }

  void onUnAuthorizedException() {}

  void setError(e, stackTrace, {String message}){
    ErrorType errorType = ErrorType.defaultError; 
    if(e is DioError){
      e = e.error;
      if(e is UnAuthorizedException){
        stackTrace = null; 

        setUnAuthorized();
        return;
      }
      else if(e is NotSuccessException){
        stackTrace = null; 
        message = e.error; 
      }
      else{
        errorType = ErrorType.networkError;
      }
    }
    viewState = ViewState.error; 
    _viewStateError = ViewStateError( 
      errorType, 
      message: message, 
      errorMessage: e.toString(),
    );
    printErrorStack(e, stackTrace);
  }

  showErrorMessage(context, { String message }){
    if(viewStateError != null || message != null){
      if(viewStateError.isNetworkError){
        message ??= "Load Failed,Check network ";
      }
      else{
        message ??= viewStateError.message; 
      }
      Future.microtask(() {
        showToast(message, context: context);
      });
    }
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _viewStateError: $_viewStateError}';
  }

  @override
  void notifyListeners() {
    if(!_disposed){
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    debugPrint('view_state_model dispose --> $runtimeType');
    super.dispose();
  }
}


printErrorStack(e, s) {
  debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----error-----↓↓↓↓↓↓↓↓↓↓----->
$e
<-----↑↑↑↑↑↑↑↑↑↑-----error-----↑↑↑↑↑↑↑↑↑↑----->''');
  if (s != null) debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----trace-----↓↓↓↓↓↓↓↓↓↓----->
$s
<-----↑↑↑↑↑↑↑↑↑↑-----trace-----↑↑↑↑↑↑↑↑↑↑----->
    ''');
}
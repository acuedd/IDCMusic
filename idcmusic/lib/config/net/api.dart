import 'dart:convert';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';

_parseAndDecode(String response){
  return jsonDecode(response);
}

parseJson(String text){
  return compute(_parseAndDecode, text);
}

abstract class BaseHttp extends DioForNative{
  BaseHttp(){
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    interceptors..add(HeaderInterceptor());
    init();
  }

  void init();
}

class HeaderInterceptor extends InterceptorsWrapper{
  @override
  onRequest(RequestOptions options) async{
    options.connectTimeout = 1000 * 45;
    options.receiveTimeout = 1000 * 45;
    options.contentType = "application/x-www-form-urlencoded; charset=UTF-8";

    options.headers["X-Requested-With"] = "XMLHttpRequest";
    return options;
  }
}

abstract class BaseResponseData {
  int code = 0;
  String error;
  dynamic data;

  bool get success;

  BaseResponseData({this.code, this.error, this.data});

  @override
  String toString() {
    return 'BaseRespData{code: $code, message: $error, data: $data}';
  }
}

class NotSuccessException implements Exception{
  String error; 

  NotSuccessException.fromRespData(BaseResponseData respData){
    error = respData.error;
  }

  @override
  String toString() {
    return 'NotExpectedException{respData: $error}';
  }
}

class UnAuthorizedException implements Exception{
  const UnAuthorizedException();

  String toString() => 'UnAuthorizedException';
}
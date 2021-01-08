import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api.dart';

final Http http = Http();

class Http extends BaseHttp{
  @override
  void init() {
    //options.baseUrl = Url.getURL();
    interceptors..add(ApiInterceptor());
  }
}

class ApiInterceptor extends InterceptorsWrapper{
  @override
  onRequest(RequestOptions options) async{
    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
        ' \nqueryParameters: ${options.queryParameters}' +
        ' \ndata: ${options.data}');
    return options;
  }

  @override
  onResponse(Response response) {
    debugPrint('---api-response--->resp----->${response.data}');
    ResponseData respData = ResponseData.fromJson(json.decode(response.data));
    if (respData.success) {
      response.data = respData.data;
      return http.resolve(response);
    } else {
      if (respData.code == -1001) {
        // 如果cookie过期,需要清除本地存储的登录信息
        // StorageManager.localStorage.deleteItem(UserModel.keyUser);
        throw const UnAuthorizedException(); // 需要登录
      } else {
        throw NotSuccessException.fromRespData(respData);
      }
    }
  }
}

class ResponseData extends BaseResponseData{
  bool get success => 200 == code;

  ResponseData.fromJson(Map<String, dynamic> json){
    code = json["valido"];
    error = json["razon"];
    data = json;
  }
}
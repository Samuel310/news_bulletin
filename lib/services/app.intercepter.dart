import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioInterceptor extends InterceptorsWrapper {
  static Future<bool> isNectworkConnected() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      debugPrint(connectivityResult.toString());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("isNectworkConnected");
      debugPrint(e);
      return false;
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!await isNectworkConnected()) {
      return handler.reject(DioError(
          requestOptions: options,
          response: Response(requestOptions: options, data: "No Internet")));
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(response.data);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
        "onError: data  - ${err.error}, ${err.message}, ${err.type}, ${err.response}");
    super.onError(err, handler);
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_connectivity/interceptor/dio_connectivity_request_retrier.dart';
import 'package:flutter/foundation.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRestrier requestRestrier;

  RetryOnConnectionChangeInterceptor({@required this.requestRestrier});
  @override
  Future onError(DioError err) async {
    if (_shouldRetry(err)) {
      try {
        return requestRestrier.scheduleRequestRetry(err.request);
      } catch (e) {
        return e;
      }
    }
    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.DEFAULT &&
        err.error != null &&
        err.error is SocketException;
  }
}

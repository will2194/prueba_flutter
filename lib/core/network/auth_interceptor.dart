import 'dart:async';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:prueba_flutter/core/shared_prefs.dart';

class AuthInterceptor implements InterceptorContract {
  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    throw UnimplementedError();
  }

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final token = await SharedPrefs.getToken();

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    return request;
  }
}

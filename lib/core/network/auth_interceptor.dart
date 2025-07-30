import 'dart:async';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:prueba_flutter/core/shared_prefs.dart';

class AuthInterceptor implements InterceptorContract {
  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
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

import 'package:http_interceptor/http_interceptor.dart';
import 'auth_interceptor.dart';

final Client httpClient = InterceptedClient.build(
  interceptors: [AuthInterceptor()],
  requestTimeout: const Duration(seconds: 30),
);

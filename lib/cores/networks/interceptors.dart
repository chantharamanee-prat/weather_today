import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class CustomLogInterceptor extends Interceptor {
  final _logger = Logger("log_network");

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.info(
        "[${response.statusCode}] ${response.requestOptions.method} ${response.requestOptions.path}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.severe(
        "[${err.response?.statusCode}] ${err.requestOptions.method} ${err.requestOptions.path}");
    super.onError(err, handler);
  }
}

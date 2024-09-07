import 'package:dio/dio.dart';
import 'package:weather_today/cores/networks/interceptors.dart';
import 'package:weather_today/cores/utils/constants/network_constant.dart';

class DioNetwork {
  late Dio weatherApi;

  void initialize() {
    weatherApi = Dio(BaseOptions(
      baseUrl: weatherUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 30),
      
    ));

    // add interceptor
    weatherApi.interceptors.add(CustomLogInterceptor());
  }
}

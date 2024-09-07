import 'package:logging/logging.dart';
import 'package:weather_today/cores/errors/exceptions.dart';
import 'package:weather_today/cores/networks/dio_network.dart';
import 'package:weather_today/features/weather/data/models/weather_model.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather({required GetWeatherParams params});
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final _logger = Logger("weather_remote_data_source_impl");

  final DioNetwork dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<WeatherModel> getWeather({required GetWeatherParams params}) async {
    try {
      final response =
          await dio.weatherApi.get("", queryParameters: params.toJson());
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      _logger.severe(e);
      throw ServerException();
    }
  }
}

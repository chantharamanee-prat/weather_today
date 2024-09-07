import 'package:dartz/dartz.dart';
import 'package:weather_today/cores/errors/failure.dart';
import 'package:weather_today/features/weather/business/entities/weather_entity.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather(
      {required GetWeatherParams params});
}

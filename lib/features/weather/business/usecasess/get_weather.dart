import 'package:dartz/dartz.dart';
import 'package:weather_today/cores/errors/failure.dart';
import 'package:weather_today/features/weather/business/entities/weather_entity.dart';
import 'package:weather_today/features/weather/business/repositories/weather_repository.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

class GetWeather {
  final WeatherRepository repository;

  const GetWeather(this.repository);

  Future<Either<Failure, WeatherEntity>> call(
      {required GetWeatherParams params}) {
    return repository.getWeather(params: params);
  }
}

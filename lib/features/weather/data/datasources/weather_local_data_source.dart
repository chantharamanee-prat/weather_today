import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:weather_today/cores/cached/local_cached_impl.dart';
import 'package:weather_today/cores/errors/exceptions.dart';
import 'package:weather_today/features/weather/data/models/weather_model.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(
      {required GetWeatherParams params, required WeatherModel weatherToCache});
  Future<WeatherModel> getWeather({required GetWeatherParams params});
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final _cachedWeatherPrefix = "CACHED_WEATHER_";
  final _logger = Logger("weather_local_data_source_impl");

  final LocalCachedImpl localCache;

  WeatherLocalDataSourceImpl({required this.localCache});

  @override
  Future<void> cacheWeather({
    required GetWeatherParams params,
    required WeatherModel weatherToCache,
  }) async {
    try {
      localCache.set("$_cachedWeatherPrefix${params.toString()}",
          json.encode(weatherToCache.toJson()));
    } catch (e) {
      _logger.severe(e);
      throw CacheException();
    }
  }

  @override
  Future<WeatherModel> getWeather({required GetWeatherParams params}) async {
    var cacheResult = await localCache.get(
      "$_cachedWeatherPrefix${params.toString()}",
    );

    if (cacheResult == null) {
      throw CacheException();
    }
    return WeatherModel.fromJson(json.decode(cacheResult));
  }
}

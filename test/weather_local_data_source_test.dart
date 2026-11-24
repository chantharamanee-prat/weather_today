import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_today/cores/cached/local_cached_impl.dart';
import 'package:weather_today/cores/errors/exceptions.dart';
import 'package:weather_today/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

void main() {
  const params = GetWeatherParams(city: 'New York');
  const cacheKey = 'CACHED_WEATHER_New York-';
  final source = WeatherLocalDataSourceImpl(localCache: LocalCachedImpl());

  test('Reads weather stored in the existing cache format', () async {
    SharedPreferences.setMockInitialValues({
      cacheKey: '{"city":"New York","condition":"Cloudy","humidity":"61",'
          '"temp":"12.5","visibleKM":"10.0","windKPH":"18.2"}',
    });

    final weather = await source.getWeather(params: params);

    expect(weather.city, 'New York');
    expect(weather.condition, 'Cloudy');
    expect(weather.humidity, '61');
    expect(weather.temp, '12.5');
    expect(weather.visibleKM, '10.0');
    expect(weather.windKPH, '18.2');
  });

  test('Reports invalid cached weather as a cache failure', () async {
    SharedPreferences.setMockInitialValues({cacheKey: '{}'});

    await expectLater(
      source.getWeather(params: params),
      throwsA(isA<CacheException>()),
    );
  });
}

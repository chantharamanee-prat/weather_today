import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_today/features/weather/data/models/weather_model.dart';

Map<String, dynamic> _hour(int epoch, String time, num temp) => {
      'time_epoch': epoch,
      'time': '2026-11-24 $time',
      'temp_c': temp,
      'condition': {'icon': '//cdn.weatherapi.com/h.png'},
    };

void main() {
  final json = {
    'location': {'name': 'New York', 'localtime_epoch': 7200 + 1800},
    'current': {
      'temp_c': 9.0,
      'feelslike_c': 6.5,
      'last_updated': '2026-11-24 13:30',
      'humidity': 57,
      'vis_km': 10.0,
      'wind_kph': 14.4,
      'condition': {'text': 'Cloudy', 'icon': '//cdn.weatherapi.com/c.png'},
    },
    'forecast': {
      'forecastday': [
        {
          'hour': [
            _hour(3600, '01:00', 5),
            _hour(7200, '02:00', 6),
            _hour(10800, '03:00', 7),
          ],
        },
        {
          'hour': [_hour(14400, '00:00', 8)],
        },
      ],
    },
  };

  test('Parses forecast.json starting from the current hour', () {
    final weather = WeatherModel.fromJson(json);

    expect(weather.iconUrl, 'https://cdn.weatherapi.com/c.png');
    expect(weather.feelsLike, '6.5');
    expect(weather.lastUpdated, '13:30');
    expect(weather.hourly.map((h) => h.time), ['02:00', '03:00', '00:00']);
    expect(weather.hourly.first.temp, '6');
    expect(weather.hourly.first.iconUrl, 'https://cdn.weatherapi.com/h.png');
  });

  test('Round-trips the new fields through the cache format', () {
    final cached = WeatherModel.fromCacheJson(
        jsonDecode(jsonEncode(WeatherModel.fromJson(json).toJson())));

    expect(cached.feelsLike, '6.5');
    expect(cached.lastUpdated, '13:30');
    expect(cached.hourly.map((h) => h.time), ['02:00', '03:00', '00:00']);
  });
}

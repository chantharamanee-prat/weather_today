import 'package:weather_today/features/weather/business/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.city,
    required super.condition,
    required super.humidity,
    required super.temp,
    required super.visibleKM,
    required super.windKPH,
    super.iconUrl,
    super.feelsLike,
    super.lastUpdated,
    super.hourly,
  });

  // mapping from https://api.weatherapi.com/v1/forecast.json
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final nowEpoch = json['location']['localtime_epoch'] as int;
    final hours = [
      for (final day in json['forecast']['forecastday'] as List)
        ...day['hour'] as List,
    ];

    return WeatherModel(
      city: json['location']['name'].toString(),
      condition: current['condition']['text'].toString(),
      humidity: current['humidity'].toString(),
      temp: current['temp_c'].toString(),
      visibleKM: current['vis_km'].toString(),
      windKPH: current['wind_kph'].toString(),
      iconUrl: _iconUrl(current['condition']['icon']),
      feelsLike: current['feelslike_c'].toString(),
      lastUpdated: _clock(current['last_updated']),
      hourly: hours
          // Keep the current hour, then the next 23.
          .where((hour) => (hour['time_epoch'] as int) > nowEpoch - 3600)
          .take(24)
          .map((hour) => HourlyForecastEntity(
                time: _clock(hour['time']),
                temp: hour['temp_c'].toString(),
                iconUrl: _iconUrl(hour['condition']['icon']),
              ))
          .toList(),
    );
  }

  factory WeatherModel.fromCacheJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'] as String,
      condition: json['condition'] as String,
      humidity: json['humidity'] as String,
      temp: json['temp'] as String,
      visibleKM: json['visibleKM'] as String,
      windKPH: json['windKPH'] as String,
      iconUrl: json['iconUrl'] as String? ?? '',
      feelsLike: json['feelsLike'] as String? ?? '',
      lastUpdated: json['lastUpdated'] as String? ?? '',
      hourly: [
        for (final hour in json['hourly'] as List? ?? const [])
          HourlyForecastEntity(
            time: hour['time'] as String,
            temp: hour['temp'] as String,
            iconUrl: hour['iconUrl'] as String,
          ),
      ],
    );
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'condition': condition,
        'humidity': humidity,
        'temp': temp,
        'visibleKM': visibleKM,
        'windKPH': windKPH,
        'iconUrl': iconUrl,
        'feelsLike': feelsLike,
        'lastUpdated': lastUpdated,
        'hourly': [
          for (final hour in hourly)
            {'time': hour.time, 'temp': hour.temp, 'iconUrl': hour.iconUrl},
        ],
      };

  // API icons are protocol-relative: "//cdn.weatherapi.com/...".
  static String _iconUrl(Object? icon) => 'https:$icon';

  // "2026-11-24 13:00" -> "13:00"
  static String _clock(Object? dateTime) => dateTime.toString().split(' ').last;
}

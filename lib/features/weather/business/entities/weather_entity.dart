class WeatherEntity {
  final String city;
  final String temp;
  final String windKPH;
  final String humidity;
  final String visibleKM;
  final String condition;
  final String iconUrl;
  final String feelsLike;
  final String lastUpdated;
  final List<HourlyForecastEntity> hourly;

  const WeatherEntity({
    required this.city,
    required this.temp,
    required this.windKPH,
    required this.humidity,
    required this.visibleKM,
    required this.condition,
    this.iconUrl = '',
    this.feelsLike = '',
    this.lastUpdated = '',
    this.hourly = const [],
  });
}

class HourlyForecastEntity {
  final String time;
  final String temp;
  final String iconUrl;

  const HourlyForecastEntity({
    required this.time,
    required this.temp,
    required this.iconUrl,
  });
}

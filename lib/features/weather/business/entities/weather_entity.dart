class WeatherEntity {
  final String city;
  final String temp;
  final String windKPH;
  final String humidity;
  final String visibleKM;
  final String condition;

  const WeatherEntity({
    required this.city,
    required this.temp,
    required this.windKPH,
    required this.humidity,
    required this.visibleKM,
    required this.condition,
  });
}

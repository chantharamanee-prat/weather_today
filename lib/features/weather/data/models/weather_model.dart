import 'package:weather_today/features/weather/business/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  WeatherModel(
      {required super.city,
      required super.condition,
      required super.humidity,
      required super.temp,
      required super.visibleKM,
      required super.windKPH});

  // mapping from https://api.weatherapi.com/v1/current.json
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['location']['name'].toString(),
      condition: json['current']['condition']['text'].toString(),
      humidity: json['current']['humidity'].toString(),
      temp: json['current']['temp_c'].toString(),
      visibleKM: json['current']['vis_km'].toString(),
      windKPH: json['current']['wind_kph'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'condition': condition,
        'humidity': humidity,
        'temp': temp,
        'visibleKM': visibleKM,
        'windKPH': windKPH,
      };
}

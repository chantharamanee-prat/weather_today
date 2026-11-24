part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

final class WeatherRequested extends WeatherEvent {
  final GetWeatherParams params;

  WeatherRequested({required this.params});
}

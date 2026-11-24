import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:weather_today/features/weather/business/entities/weather_entity.dart';
import 'package:weather_today/features/weather/business/usecasess/get_weather.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required GetWeather getWeather}) : super(WeatherInitial()) {
    on<WeatherRequested>((event, emit) async {
      emit(WeatherLoading());
      final result = await getWeather(params: event.params);
      result.fold(
        (failure) => emit(WeatherError(failure.errorMessage)),
        (weather) => emit(WeatherLoaded(weather)),
      );
    });
  }
}

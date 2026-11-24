import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_today/cores/injection.dart';
import 'package:weather_today/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_today/features/weather/presentation/pages/weather_page.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) {
      const params = GetWeatherParams(city: 'New York');

      return BlocProvider(
        create: (_) =>
            locator<WeatherBloc>()..add(WeatherRequested(params: params)),
        child: const WeatherPage(params: params),
      );
    },
  ),
]);

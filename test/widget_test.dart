import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_today/cores/errors/failure.dart';
import 'package:weather_today/cores/injection.dart';
import 'package:weather_today/features/weather/business/entities/weather_entity.dart';
import 'package:weather_today/features/weather/business/repositories/weather_repository.dart';
import 'package:weather_today/features/weather/business/usecasess/get_weather.dart';
import 'package:weather_today/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_today/features/weather/presentation/pages/weather_page.dart';
import 'package:weather_today/features/weather/presentation/widgets/weather_widgets.dart';
import 'package:weather_today/main.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

void main() {
  final colorsByTemperature = {
    '19.9': const Color(0xFF219EBC),
    '20': Colors.pink.shade400,
    '25.5': Colors.pink.shade400,
    '30': Colors.pink.shade400,
    '30.1': Colors.yellow.shade600,
    'unavailable': Colors.pink.shade400,
  };

  for (final MapEntry(key: temperature, value: color)
      in colorsByTemperature.entries) {
    testWidgets('Updates weather colors for $temperature', (tester) async {
      final repository = _WeatherRepositoryStub();
      final bloc = WeatherBloc(getWeather: GetWeather(repository));
      addTearDown(bloc.close);
      const params = GetWeatherParams(city: 'New York');

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const WeatherPage(params: params),
        ),
      ));
      bloc.add(WeatherRequested(params: params));
      repository.response.complete(Right(WeatherEntity(
        city: params.city,
        temp: temperature,
        windKPH: '18.2',
        humidity: '61',
        visibleKM: '10.0',
        condition: 'Partly cloudy',
      )));
      await tester.pumpAndSettle();

      expect(tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
          color);
      expect(tester.widget<AppBar>(find.byType(AppBar)).backgroundColor, color);
      expect(find.byType(WeatherInfoCardItem), findsNWidgets(3));
      final items = tester
          .widgetList<WeatherInfoCardItem>(find.byType(WeatherInfoCardItem));
      expect(items.map((item) => item.color), everyElement(color));
    });
  }

  testWidgets('Loads New York weather and retries after a failure',
      (tester) async {
    final repository = _WeatherRepositoryStub();
    await injectService();
    addTearDown(locator.reset);
    await locator.unregister<WeatherRepository>();
    locator.registerSingleton<WeatherRepository>(repository);

    await tester.pumpWidget(const App());
    await tester.pump();

    expect(repository.requestedCities, ['New York']);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    repository.response.complete(
      Left(ServerFailure(errorMessage: 'Weather is unavailable.')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Weather is unavailable.'), findsOneWidget);

    repository.response = Completer<Either<Failure, WeatherEntity>>();
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(repository.requestedCities, ['New York', 'New York']);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    repository.response.complete(const Right(WeatherEntity(
      city: 'New York',
      temp: '12.5',
      windKPH: '18.2',
      humidity: '61',
      visibleKM: '10.0',
      condition: 'Partly cloudy',
    )));
    await tester.pumpAndSettle();

    expect(find.text('New York'), findsOneWidget);
    expect(find.text('Partly cloudy'), findsOneWidget);
    expect(find.text('12.5°C'), findsOneWidget);
    expect(find.text('18.2 km/h'), findsOneWidget);
    expect(find.text('61%'), findsOneWidget);
    expect(find.text('10.0 km'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });
}

class _WeatherRepositoryStub implements WeatherRepository {
  final requestedCities = <String>[];
  var response = Completer<Either<Failure, WeatherEntity>>();

  @override
  Future<Either<Failure, WeatherEntity>> getWeather({
    required GetWeatherParams params,
  }) {
    requestedCities.add(params.city);
    return response.future;
  }
}

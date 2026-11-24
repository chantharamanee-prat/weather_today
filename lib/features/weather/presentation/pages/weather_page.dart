import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_today/features/weather/business/entities/weather_entity.dart';
import 'package:weather_today/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_today/features/weather/presentation/widgets/weather_widgets.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key, required this.params});

  final GetWeatherParams params;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = Colors.pink.shade400;

    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            centerTitle: true,
            title: Text(
              switch (state) {
                WeatherLoaded(:final weather) => weather.city,
                _ => params.city,
              },
              style: theme.textTheme.titleLarge,
            ),
          ),
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: switch (state) {
              WeatherInitial() || WeatherLoading() => const Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Loading weather',
                  ),
                ),
              WeatherLoaded(:final weather) => _WeatherDetails(
                  weather: weather,
                  color: backgroundColor,
                ),
              WeatherError(:final message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(message, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context
                              .read<WeatherBloc>()
                              .add(WeatherRequested(params: params)),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
            },
          ),
        );
      },
    );
  }
}

class _WeatherDetails extends StatelessWidget {
  const _WeatherDetails({required this.weather, required this.color});

  final WeatherEntity weather;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            weather.condition,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium,
          ),
          Text(
            '${weather.temp}°C',
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(2),
            style: textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text('Current conditions', style: textTheme.titleMedium),
          WeatherInfoCard(
            children: [
              WeatherInfoCardItem(
                color: color,
                icon: Icons.wind_power_rounded,
                value: '${weather.windKPH} km/h',
                subtitle: 'Wind',
              ),
              WeatherInfoCardItem(
                color: color,
                icon: Icons.water_drop_outlined,
                value: '${weather.humidity}%',
                subtitle: 'Humidity',
              ),
              WeatherInfoCardItem(
                color: color,
                icon: Icons.remove_red_eye_outlined,
                value: '${weather.visibleKM} km',
                subtitle: 'Visibility',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

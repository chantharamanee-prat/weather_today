import 'package:flutter/material.dart';
import 'package:weather_today/features/weather/business/entities/weather_entity.dart';
import 'package:weather_today/features/weather/presentation/widgets/weather_icon.dart';

class WeatherForecast extends StatelessWidget {
  const WeatherForecast({super.key, required this.hourly, this.color});

  final List<HourlyForecastEntity> hourly;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fontColor = color ?? Colors.white;

    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        itemCount: hourly.length,
        separatorBuilder: (_, __) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final hour = hourly[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(index == 0 ? 'Now' : hour.time,
                  style: textTheme.bodySmall?.copyWith(color: fontColor)),
              WeatherIcon(url: hour.iconUrl, size: 40),
              Text('${hour.temp}°',
                  style: textTheme.bodyLarge?.copyWith(color: fontColor)),
            ],
          );
        },
      ),
    );
  }
}

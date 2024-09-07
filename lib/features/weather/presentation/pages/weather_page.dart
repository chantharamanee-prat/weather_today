import 'package:flutter/material.dart';
import 'package:weather_today/features/weather/presentation/widgets/weather_widgets.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = Colors.pink[400];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text(
          "New York",
          style: theme.textTheme.titleLarge,
        ),
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      "Friday, 20 January",
                      style:
                          theme.textTheme.titleMedium?.copyWith(color: bgColor),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sunny",
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    "31 ํ",
                    textScaler: const TextScaler.linear(3),
                    style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Daily Summary",
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.",
                        style: theme.textTheme.bodySmall,
                      ),
                      WeatherInfoCard(
                        color: bgColor,
                        children: [
                          WeatherInfoCardItem(
                            color: bgColor,
                            icon: Icons.wind_power_rounded,
                            value: "40km/h",
                            subtitle: "Wind",
                          ),
                         WeatherInfoCardItem(
                            color: bgColor,
                            icon: Icons.water_drop_outlined,
                            value: "48%",
                            subtitle: "Humidity",
                          ),
                          WeatherInfoCardItem(
                            color: bgColor,
                            icon: Icons.remove_red_eye_outlined,
                            value: "10km",
                            subtitle: "Visibility",
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

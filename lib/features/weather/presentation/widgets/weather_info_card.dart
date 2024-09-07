import 'package:flutter/material.dart';
import 'package:weather_today/features/weather/presentation/widgets/weather_info_card_item.dart';

class WeatherInfoCard extends StatelessWidget {
  const WeatherInfoCard({super.key, this.color, required this.children});
  final Color? color;
  final List<WeatherInfoCardItem> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}

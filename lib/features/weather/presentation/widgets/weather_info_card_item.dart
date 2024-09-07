import 'package:flutter/material.dart';

class WeatherInfoCardItem extends StatelessWidget {
  const WeatherInfoCardItem({
    super.key,
    this.color,
    required this.icon,
    required this.value,
    required this.subtitle,
  });

  final Color? color;
  final IconData icon;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor = color ?? Colors.white;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: fontColor,
          size: 34,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(color: fontColor),
        ),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: fontColor),
        )
      ],
    );
  }
}

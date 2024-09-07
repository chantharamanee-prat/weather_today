import 'package:go_router/go_router.dart';
import 'package:weather_today/features/weather/presentation/pages/weather_page.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (ctx, state) => const WeatherPage(),
  ),
]);

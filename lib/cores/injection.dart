import 'package:get_it/get_it.dart';
import 'package:weather_today/cores/cached/local_cached_impl.dart';
import 'package:weather_today/cores/networks/connection_info.dart';
import 'package:weather_today/cores/networks/dio_network.dart';
import 'package:weather_today/cores/utils/log/log.dart';
import 'package:weather_today/features/weather/weather_injection.dart';

final locator = GetIt.instance;

Future<void> injectService() async {
  initializeLog();

  // register service
  locator.registerLazySingleton<DioNetwork>(() {
    var dioNw = DioNetwork();
    dioNw.initialize();
    return dioNw;
  });

  locator.registerLazySingleton<ConnectionInfoImpl>(() => ConnectionInfoImpl());
  locator.registerLazySingleton<LocalCachedImpl>(() => LocalCachedImpl());

  injectWeather();
}

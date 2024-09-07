import 'package:weather_today/cores/injection.dart';
import 'package:weather_today/features/weather/business/repositories/weather_repository.dart';
import 'package:weather_today/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weather_today/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_today/features/weather/data/repositories/weather_repository_impl.dart';

void injectWeather() {
  locator.registerLazySingleton<WeatherRepository>(() {
    return WeatherRepositoryImpl(
      connectionInfo: locator.get(),
      localDataSource: WeatherLocalDataSourceImpl(localCache: locator.get()),
      remoteDataSource: WeatherRemoteDataSourceImpl(dio: locator.get()),
    );
  });
}

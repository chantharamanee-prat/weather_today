import 'package:dartz/dartz.dart';
import 'package:weather_today/cores/errors/exceptions.dart';
import 'package:weather_today/cores/errors/failure.dart';
import 'package:weather_today/cores/networks/connection_info.dart';
import 'package:weather_today/features/weather/business/entities/weather_entity.dart';
import 'package:weather_today/features/weather/business/repositories/weather_repository.dart';
import 'package:weather_today/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weather_today/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_today/shared/params/get_weather_params.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final ConnectionInfo connectionInfo;

  final WeatherLocalDataSource localDataSource;
  final WeatherRemoteDataSource remoteDataSource;

  const WeatherRepositoryImpl({
    required this.connectionInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(
      {required GetWeatherParams params}) async {
    if (await connectionInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getWeather(params: params);
        localDataSource.cacheWeather(
            params: params, weatherToCache: remoteData);

        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure(
            errorMessage: "Cannot retrieve data from the server."));
      }
    } else {
      try {
        final localData = await localDataSource.getWeather(params: params);
        return Right(localData);
      } on CacheException {
        return Left(CacheFailure(errorMessage: "No loca data found."));
      }
    }
  }
}

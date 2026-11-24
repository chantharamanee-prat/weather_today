# weather_today

A Flutter weather app. It shows the current weather and a 24-hour forecast
for a city, using data from [WeatherAPI.com](https://www.weatherapi.com/).
When the device is offline, it shows the last weather it saved.

The code follows **clean architecture**, based on
[flutter_mapp_clean_architecture](https://github.com/fluttermapp/flutter_mapp_clean_architecture/tree/master).

## Getting started

1. Use Flutter **3.22.2** (pinned in `.fvmrc`; with FVM run `fvm use`).
2. Copy `.env.example` to `.env` and set `WEATHER_API_KEY` to your
   WeatherAPI.com key.
3. Run the app:

   ```sh
   flutter pub get
   flutter run --dart-define-from-file=.env
   ```

   VS Code loads `.env` for you when you launch from the editor.

Run the tests with `flutter test`.

## Project structure

```text
lib/
├── main.dart                    # starts DI, then runs the app
├── cores/                       # shared, feature-independent code
│   ├── injection.dart           # GetIt setup (locator)
│   ├── networks/                # Dio client, interceptor, connection check
│   ├── cached/                  # SharedPreferences wrapper
│   ├── errors/                  # Exceptions (data) and Failures (business)
│   ├── routes/router.dart       # GoRouter, creates the WeatherBloc
│   └── utils/constants/         # API URL and API key
├── shared/params/               # GetWeatherParams (request input)
└── features/weather/
    ├── weather_injection.dart   # registers this feature in GetIt
    ├── business/                # domain layer: pure Dart, no Flutter/Dio
    │   ├── entities/            # WeatherEntity, HourlyForecastEntity
    │   ├── repositories/        # WeatherRepository (abstract contract)
    │   └── usecasess/           # GetWeather use case
    ├── data/                    # data layer: talks to API and cache
    │   ├── models/              # WeatherModel (JSON <-> entity)
    │   ├── datasources/         # remote (Dio) and local (SharedPreferences)
    │   └── repositories/        # WeatherRepositoryImpl
    └── presentation/            # UI layer
        ├── bloc/                # WeatherBloc, events, states
        ├── pages/               # WeatherPage
        └── widgets/             # cards, forecast list, icon
```

### The dependency rule

```text
presentation  ──►  business  ◄──  data
```

- **business** knows nothing about the other layers. It only defines the
  entity, the repository contract, and the use case.
- **data** implements the contract from business.
- **presentation** calls the use case and only sees entities.

`GetIt` (`lib/cores/injection.dart` and `weather_injection.dart`) connects
the concrete classes at start-up, so no layer creates its own dependencies.

## Data flow

This is the full path of one request, from app start to pixels on the
screen.

```text
 USER opens app
   │
   ▼
 GoRouter "/"                         cores/routes/router.dart
   │  creates WeatherBloc, adds WeatherRequested(city: "New York")
   ▼
┌───────────────────────── PRESENTATION ─────────────────────────┐
│ WeatherBloc                                                    │
│   emit WeatherLoading ───────────────► spinner on WeatherPage  │
│   call GetWeather(params)                                      │
└───────────────┬────────────────────────────────────────────────┘
                ▼
┌─────────────────────────── BUSINESS ───────────────────────────┐
│ GetWeather  ──►  WeatherRepository (abstract)                  │
│ returns Future<Either<Failure, WeatherEntity>>                 │
└───────────────┬────────────────────────────────────────────────┘
                ▼
┌───────────────────────────── DATA ─────────────────────────────┐
│ WeatherRepositoryImpl                                          │
│   ConnectionInfo.isConnected ?                                 │
│     yes ─► WeatherRemoteDataSource ─► Dio GET forecast.json    │
│            JSON ─► WeatherModel.fromJson                       │
│            save to WeatherLocalDataSource (SharedPreferences)  │
│            return Right(model)                                 │
│            on ServerException ─► Left(ServerFailure)           │
│     no  ─► WeatherLocalDataSource.getWeather                   │
│            cached JSON ─► WeatherModel.fromCacheJson           │
│            return Right(model)                                 │
│            on CacheException ─► Left(CacheFailure)             │
└───────────────┬────────────────────────────────────────────────┘
                ▼
 WeatherBloc folds the Either
   Left(failure)  ─► emit WeatherError(message)
   Right(weather) ─► emit WeatherLoaded(weather)
                ▼
 WeatherPage (BlocBuilder) rebuilds ─► USER sees the weather
```

### Step by step, per component

#### 1. Start-up — `main.dart`, `cores/injection.dart`, `weather_injection.dart`

`main()` calls `injectService()` before `runApp`. It registers:

| Registered type | Lifetime | Used by |
|---|---|---|
| `DioNetwork` | lazy singleton | remote data source |
| `ConnectionInfo` | lazy singleton | repository |
| `LocalCachedImpl` | lazy singleton | local data source |
| `WeatherRepository` → `WeatherRepositoryImpl` | lazy singleton | use case |
| `GetWeather` | lazy singleton | bloc |
| `WeatherBloc` | factory (new each time) | router |

`DioNetwork` sets the base URL (`forecast.json`) and adds the API key as a
default query parameter `key`, so no other class handles the key.

#### 2. Route — `cores/routes/router.dart`

The `/` route builds `GetWeatherParams(city: 'New York')`, gets a new
`WeatherBloc` from the locator, and adds `WeatherRequested(params)` at once.
It wraps `WeatherPage` in a `BlocProvider`, so the page can read the bloc.

#### 3. Request input — `shared/params/get_weather_params.dart`

`GetWeatherParams` carries the request through every layer:

- `toJson()` → query `{q: city, days: 2}` for the API. Two days are needed
  so the hourly list can continue past midnight.
- `toString()` → `"New York-"`, used as part of the cache key.

#### 4. Presentation: bloc — `presentation/bloc/`

`WeatherBloc` handles `WeatherRequested`:

1. emits `WeatherLoading`
2. awaits `GetWeather(params: ...)`
3. folds the result: `Left` → `WeatherError(failure.errorMessage)`,
   `Right` → `WeatherLoaded(weather)`

States are a `sealed` class, so the page must handle all four:
`WeatherInitial`, `WeatherLoading`, `WeatherLoaded`, `WeatherError`.

#### 5. Business: use case — `business/usecasess/get_weather.dart`

`GetWeather` is a callable class with one job: call
`WeatherRepository.getWeather`. It depends only on the abstract repository,
so the bloc never knows whether data came from the network or the cache.

The result type is `Either<Failure, WeatherEntity>` (from `dartz`). Errors
are returned as values, not thrown, so the bloc has no `try/catch`.

#### 6. Business: entity — `business/entities/weather_entity.dart`

`WeatherEntity` is the shape the UI uses: `city`, `temp`, `condition`,
`iconUrl`, `feelsLike`, `lastUpdated`, `windKPH`, `humidity`, `visibleKM`,
and a list of `HourlyForecastEntity` (`time`, `temp`, `iconUrl`). Values
are already formatted strings, so widgets only add units.

#### 7. Data: repository — `data/repositories/weather_repository_impl.dart`

Chooses the source and turns exceptions into failures:

| Situation | Action | Result |
|---|---|---|
| Online, API OK | fetch remote, save to cache | `Right(WeatherModel)` |
| Online, API error | — | `Left(ServerFailure("Cannot retrieve data from the server."))` |
| Offline, cache found | read cache | `Right(WeatherModel)` |
| Offline, no cache | — | `Left(CacheFailure("No cached weather available."))` |

Note: when online and the API fails, it does **not** fall back to the cache.

#### 8. Data: remote source — `data/datasources/weather_remote_data_source.dart`

Calls `dio.weatherApi.get("", queryParameters: params.toJson())`. A `200`
response is parsed with `WeatherModel.fromJson`. Any other status or any
error is logged and thrown as `ServerException`. `CustomLogInterceptor`
logs every response and error.

#### 9. Data: local source — `data/datasources/weather_local_data_source.dart`

Stores the model as JSON in SharedPreferences under the key
`CACHED_WEATHER_<city>-` (for example `CACHED_WEATHER_New York-`).
Reading uses `WeatherModel.fromCacheJson`. A missing or broken entry throws
`CacheException`.

#### 10. Data: model — `data/models/weather_model.dart`

`WeatherModel extends WeatherEntity`, so the repository can return it
directly as an entity. It has three mappers:

| Method | From → To | Used when |
|---|---|---|
| `fromJson` | WeatherAPI response → model | after a network call |
| `toJson` | model → flat JSON | saving to cache |
| `fromCacheJson` | flat JSON → model | reading from cache |

What `fromJson` does with the API response:

| API field | Entity field |
|---|---|
| `location.name` | `city` |
| `current.temp_c` | `temp` |
| `current.feelslike_c` | `feelsLike` |
| `current.condition.text` | `condition` |
| `current.condition.icon` (`//cdn...`) | `iconUrl` (adds `https:`) |
| `current.last_updated` (`2026-11-24 13:00`) | `lastUpdated` (`13:00`) |
| `current.wind_kph` / `humidity` / `vis_km` | `windKPH` / `humidity` / `visibleKM` |
| `forecast.forecastday[*].hour[*]` | `hourly`: the current hour + next 23 |

#### 11. Presentation: page and widgets — `presentation/pages/weather_page.dart`, `presentation/widgets/`

`WeatherPage` uses a `BlocBuilder` and draws one view per state:

| State | What the user sees |
|---|---|
| `WeatherInitial` / `WeatherLoading` | spinner; title = requested city |
| `WeatherError` | error message + **Retry** button (adds `WeatherRequested` again) |
| `WeatherLoaded` | full weather details (below) |

For `WeatherLoaded`, the background color comes from `temp`:
yellow above 30 °C, blue below 20 °C, pink otherwise. Then the entity
fields go to these widgets:

| Entity field | Widget | Shown as |
|---|---|---|
| `city` | `AppBar` title | `New York` |
| `condition` | `Text` | `Partly cloudy` |
| `iconUrl` | `WeatherIcon` (network image, cloud icon on error) | icon |
| `temp` | large `Text` | `17°C` |
| `feelsLike`, `lastUpdated` | `Text` | `Feels like 15°C · Updated 13:00` |
| `windKPH`, `humidity`, `visibleKM` | `WeatherInfoCard` → 3 × `WeatherInfoCardItem` | `12 km/h`, `64%`, `10 km` |
| `hourly` | `WeatherForecast` (horizontal list) | `Now`, `14:00`, … with icon and `°` |

## Other files

- `presentation/pages/city_search_prototype.dart` — a standalone design
  prototype for city search with sample data. It is not connected to the
  bloc. Run it with
  `flutter run -t lib/features/weather/presentation/pages/city_search_prototype.dart`.
- `test/` — tests for the model mapping, the local data source, and the
  page colors.
